/* test_keypad_lcd_digit3.c
 * Keypad (ioc @ 0xFF18) -> build 3-digit number -> display on LCD
 *
 * HW assumptions:
 *   - 0xFF0C: LCD/SPI (same as provided environment)
 *   - 0xFF18: ioc (cs6) where
 *       write: low 4 bits drive (ioc_lo)
 *       read : returns {ioc_hi, ioc_lo} in low 8 bits
 *     and ioc_hi inputs are active-low (pressed -> 0)
 *
 * Required files:
 *   - crt0.c
 *   - ChrFont0.h (font8x8)
 */

 #include "crt0.c"
 #include "ChrFont0.h"
 
 /* MMIO addresses */
 #define LCD_ADDR  0xff0c
 #define IOC_ADDR  0xff18
 
 /* ----------------- small delay ----------------- */
 static inline void tiny_wait(int n) { for (volatile int i = 0; i < n; i++); }
 
 /* ----------------- LCD low-level ----------------- */
 static unsigned char lcd_vbuf[64][96];
 
 static void lcd_wait(int n) { for (volatile int i = 0; i < n; i++); }
 
 static void lcd_cmd(unsigned char cmd) {
     volatile int *lcd_ptr = (int *)LCD_ADDR;
     *lcd_ptr = cmd;          /* dc=0 */
     lcd_wait(1000);
 }
 
 static void lcd_data(unsigned char data) {
     volatile int *lcd_ptr = (int *)LCD_ADDR;
     *lcd_ptr = 0x100 | data; /* dc=1 */
     lcd_wait(200);
 }
 
 static void lcd_pwr_on() {
     volatile int *lcd_ptr = (int *)LCD_ADDR;
     *lcd_ptr = 0x200;        /* power on */
     lcd_wait(700000);
 }
 
 static void lcd_init() {
     lcd_pwr_on();
     lcd_cmd(0xa0);
     lcd_cmd(0x20);
     lcd_cmd(0x15); lcd_cmd(0);  lcd_cmd(95);
     lcd_cmd(0x75); lcd_cmd(0);  lcd_cmd(63);
     lcd_cmd(0xaf);
 }
 
 static void lcd_set_vbuf_pixel(int row, int col, int r, int g, int b) {
     r >>= 5; g >>= 5; b >>= 6;
     lcd_vbuf[row][col] = ((r << 5) | (g << 2) | (b << 0)) & 0xff;
 }
 
 static void lcd_clear_vbuf() {
     for (int row = 0; row < 64; row++)
         for (int col = 0; col < 96; col++)
             lcd_vbuf[row][col] = 0;
 }
 
 static void lcd_sync_vbuf() {
     for (int row = 0; row < 64; row++)
         for (int col = 0; col < 96; col++)
             lcd_data(lcd_vbuf[row][col]);
 }
 
 /* 8x8 font draw (green) */
 static void lcd_putc(int y, int x, int c) {
     if (c < 0x20 || c > 0x7f) return;
     for (int v = 0; v < 8; v++)
         for (int h = 0; h < 8; h++)
             if ((font8x8[(c - 0x20) * 8 + h] >> v) & 0x01)
                 lcd_set_vbuf_pixel(y * 8 + v, x * 8 + h, 0, 255, 0);
 }
 
 static void lcd_puts(int y, int x, const char *s) {
     for (int i = 0; s[i] && (x + i) < 12; i++) lcd_putc(y, x + i, s[i]);
 }
 
 /* ----------------- lcd_digit3 (from the slide) ----------------- */
 static void lcd_digit3(int y, int x, unsigned int val) {
     int digit3, digit2, digit1;
     digit3 = (val < 100)  ? ' ' : ((val % 1000) / 100) + '0';
     digit2 = (val < 10)   ? ' ' : ((val % 100)  / 10)  + '0';
     digit1 = (val % 10) + '0';
     lcd_putc(y, x + 0, digit3);
     lcd_putc(y, x + 1, digit2);
     lcd_putc(y, x + 2, digit1);
 }
 
 /* ----------------- Keypad scan on IOC -----------------
  * Returns: 0 if none, else 0x0..0xF according to typical 4x4 mapping.
  * Active-low assumed (pressed => input bit becomes 0).
  */
 static inline unsigned char ioc_read_raw8() {
     volatile int *ioc_ptr = (int *)IOC_ADDR;
     return (unsigned char)(*ioc_ptr & 0xff);
 }
 
 static int kypd_scan(unsigned char *raw_out) {
     volatile int *ioc_ptr = (int *)IOC_ADDR;
 
     /* row0 */
     *ioc_ptr = 0x07; tiny_wait(300);
     unsigned char raw = ioc_read_raw8();
     if (raw_out) *raw_out = raw;
     if ((raw & 0x80) == 0) return 0x1;
     if ((raw & 0x40) == 0) return 0x4;
     if ((raw & 0x20) == 0) return 0x7;
     if ((raw & 0x10) == 0) return 0x0;
 
     /* row1 */
     *ioc_ptr = 0x0b; tiny_wait(300);
     raw = ioc_read_raw8();
     if (raw_out) *raw_out = raw;
     if ((raw & 0x80) == 0) return 0x2;
     if ((raw & 0x40) == 0) return 0x5;
     if ((raw & 0x20) == 0) return 0x8;
     if ((raw & 0x10) == 0) return 0xf; /* often 'F' key */
 
     /* row2 */
     *ioc_ptr = 0x0d; tiny_wait(300);
     raw = ioc_read_raw8();
     if (raw_out) *raw_out = raw;
     if ((raw & 0x80) == 0) return 0x3;
     if ((raw & 0x40) == 0) return 0x6;
     if ((raw & 0x20) == 0) return 0x9;
     if ((raw & 0x10) == 0) return 0xe;
 
     /* row3 */
     *ioc_ptr = 0x0e; tiny_wait(300);
     raw = ioc_read_raw8();
     if (raw_out) *raw_out = raw;
     if ((raw & 0x80) == 0) return 0xa;
     if ((raw & 0x40) == 0) return 0xb;
     if ((raw & 0x20) == 0) return 0xc;
     if ((raw & 0x10) == 0) return 0xd;
 
     return 0;
 }
 
 /* ----------------- UI state (shown in interrupt) ----------------- */
 volatile unsigned int frame_counter = 0;
 volatile unsigned int value3 = 0;     /* 0..999 */
 volatile unsigned char last_raw = 0;  /* debug */
 volatile int last_key = 0;            /* debug */
 
 /* 100ms interrupt: redraw screen */
 void interrupt_handler() {
     frame_counter++;
 
     lcd_clear_vbuf();
     lcd_puts(0, 0, "KEYPAD -> LCD");
     lcd_puts(2, 0, "VALUE:");
     lcd_digit3(2, 7, value3);
 
     lcd_puts(4, 0, "KEY:");
     lcd_putc(4, 5, "0123456789ABCDEF"[last_key & 0xF]);
 
     lcd_puts(5, 0, "RAW:0x");
     /* show raw as two hex digits */
     static const char *hex = "0123456789ABCDEF";
     lcd_putc(5, 6, hex[(last_raw >> 4) & 0xF]);
     lcd_putc(5, 7, hex[(last_raw >> 0) & 0xF]);
 
     lcd_puts(7, 0, "0-9 add, F clr");
 
     lcd_sync_vbuf();
 }
 
 /* ----------------- main: accept key edges ----------------- */
 void main() {
     lcd_init();
     lcd_clear_vbuf();
     lcd_sync_vbuf();
 
     int prev_nonzero = 0;
 
     while (1) {
         unsigned char raw = 0;
         int key = kypd_scan(&raw);
 
         last_raw = raw;
         last_key = key;
 
         /* Edge detect: accept only when going from "none" to "some key" */
         if (key != 0 && !prev_nonzero) {
             if (key <= 9) {
                 /* append digit (max 3 digits) */
                 value3 = (value3 * 10 + (unsigned int)key) % 1000;
             } else if (key == 0xF) {
                 /* clear */
                 value3 = 0;
             }
         }
 
         prev_nonzero = (key != 0);
 
         /* slow down loop a bit */
         tiny_wait(4000);
     }
 }