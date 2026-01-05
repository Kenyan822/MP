/* Do not remove the following line. Do not remove interrupt_handler(). */
#include "crt0.c"
#include "ChrFont0.h"

/*
 * 関数プロトタイプ宣言
 */
void lcd_init();
void lcd_putc(int y, int x, int c);
void lcd_puts(int y, int x, char *str);
void lcd_putc_color(int y, int x, int c, int r, int g, int b);
void lcd_puts_color(int y, int x, char *str, int r, int g, int b);
void lcd_sync_vbuf();
void lcd_clear_vbuf();
void lcd_set_vbuf_pixel(int row, int col, int r, int g, int b);

void led_set(int data);
void led_blink();

int btn_check_0();
int btn_check_1();
int btn_check_2();
int btn_check_3();

int rotary_read();
int kypd_scan();
void kypd_scan_both(volatile int *p1_dir, volatile int *p2_dir);

void buzzer_play(int mode);
void buzzer_stop();

void draw_mode_select(int cursor);
void draw_tennis_game();
void draw_racket(int x, int y, int r, int g, int b);
void draw_ball(int x, int y);

void draw_squash_game();
void draw_squash_background();
void draw_squash_walls();
void draw_squash_racket(int x, int y, int r, int g, int b);
void draw_squash_ball(int x, int y);
void draw_squash_score(int score);
void draw_lives(int lives);
void draw_turn_indicator(int turn, int frame);
void squash_update();
void squash_move_players();
void draw_result_squash(int score);

/*
 * ゲームステート定義
 */
#define STATE_INIT      0   /* 初期化 */
#define STATE_SELECT    1   /* モード選択画面 */
#define STATE_WAIT      2   /* 待機画面（スタート待ち） */
#define STATE_PLAY      3   /* プレイ中 */
#define STATE_RESULT    4   /* 結果画面 */

/*
 * ゲームモード定義
 */
#define MODE_TENNIS     0   /* テニス */
#define MODE_SQUASH_1P  1   /* スカッシュ1人 */
#define MODE_SQUASH_2P  2   /* スカッシュ2人 */

/*
 * テニスモード定数
 */
#define RACKET_WIDTH  8
#define RACKET_HEIGHT 12
#define BALL_SIZE     4
#define P1_X          2    /* プレイヤー1のX座標（固定） */
#define P2_X          86   /* プレイヤー2のX座標（固定） */

/*
 * スカッシュモード定数
 */
#define WALL_THICKNESS  4
#define PLAYER_SIZE     8
#define PLAYER_SPEED    4
#define HIT_RANGE       10

/* ラケットパターン (1:フレーム, 2:ガット, 0:透過) */
const unsigned char RACKET_PATTERN[12][8] = {
    {0,0,1,1,1,1,0,0},
    {0,1,2,2,2,2,1,0},
    {0,1,2,2,2,2,1,0},
    {0,1,2,2,2,2,1,0},
    {0,1,2,2,2,2,1,0},
    {0,0,1,1,1,1,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,1,1,0,0,0},
    {0,0,0,1,1,0,0,0}
};

/* プレイヤースプライトパターン (1:描画, 0:透過) */
const unsigned char PLAYER_PATTERN[8][8] = {
    {0,0,1,1,1,1,0,0},  /* 頭部上 */
    {0,1,1,0,0,1,1,0},  /* 頭部 */
    {0,0,1,1,1,1,0,0},  /* 頭部下 */
    {0,0,0,1,1,0,0,0},  /* 首 */
    {0,0,1,1,1,1,0,0},  /* 胴体 */
    {0,1,1,0,0,1,1,0},  /* 腕 */
    {0,1,1,0,0,1,1,0},  /* 足上 */
    {0,1,0,0,0,0,1,0}   /* 足下 */
};

/*
 * グローバル変数
 */
volatile int game_state = STATE_INIT;
volatile int game_mode = MODE_TENNIS;
volatile int cursor = 0;                 /* モード選択カーソル位置 (0-2) */
volatile unsigned int frame_counter = 0; /* アニメーション用カウンタ */

/* ボタン入力のエッジ検出用 */
int btn0_prev = 0;
int btn2_prev = 0;
int btn3_prev = 0;

/* ロータリーエンコーダ用 */
int rotary_prev = 128;          /* 前回のカウンタ値（初期値128） */
int rotary_threshold = 4;       /* 何カウント変化でカーソル移動するか */

/* テニスモード用変数 */
int p1_x = P1_X;        /* P1ラケットX座標（2次元移動用） */
int p1_y = 24;          /* P1ラケットY座標 */
int p2_x = P2_X;        /* P2ラケットX座標（2次元移動用） */
int p2_y = 24;          /* P2ラケットY座標 */
int ball_x = 46;        /* ボールX座標 */
int ball_y = 30;        /* ボールY座標 */
int ball_vx = 3;        /* ボールX方向速度 */
int ball_vy = 2;        /* ボールY方向速度 */
int score_p1 = 0;       /* P1スコア */
int score_p2 = 0;       /* P2スコア */

/* 入力状態保存用（割り込みハンドラで使用） */
volatile int input_p1_dir = -1;  /* P1の方向入力 (1=上, 4=左, 5=右, 7=下) */
volatile int input_p2_dir = -1;  /* P2の方向入力 (A=上, 6=左, B=右, C=下) */
volatile int input_btn0 = 0;     /* ボタン0の状態 */
volatile int input_btn1 = 0;     /* ボタン1の状態 */

/* ブザー用変数 */
int buzzer_timer = 0;   /* ブザー持続フレーム数 */
#define BUZZER_SHORT 2  /* 打ち返し音の長さ（フレーム数） */
#define BUZZER_LONG  5  /* 得点音の長さ（フレーム数） */
#define TONE_HIT     8  /* 打ち返し音の音階（G） */
#define TONE_SCORE  13  /* 得点音の音階（高いC） */

/* スカッシュモード用変数 */
int sq_p1_x = 2, sq_p1_y = 20;      /* P1座標（左側配置） */
int sq_p2_x = 2, sq_p2_y = 36;      /* P2座標（左側配置） */
int sq_ball_x = 46, sq_ball_y = 26; /* ボール座標 */
int sq_ball_vx = 3, sq_ball_vy = 2; /* ボール速度 */
int sq_score = 0;                    /* スコア */
int sq_lives = 3;                    /* 残機 */
int sq_turn = 0;                     /* 現在のターン (0=P1, 1=P2) */
int sq_rally = 0;                    /* ラリー回数 */

/*
 * 割り込みハンドラ（100msecごとに呼ばれる）
 */
void interrupt_handler() {
    frame_counter++;
    
    /* ブザータイマー処理 */
    if (buzzer_timer > 0) {
        buzzer_timer--;
        if (buzzer_timer == 0) {
            buzzer_stop();
        }
    }
    
    /* モード選択画面の描画 */
    if (game_state == STATE_SELECT) {
        draw_mode_select(cursor);
    } else if (game_state == STATE_WAIT) {
        /* 待機画面の描画 */
        lcd_clear_vbuf();
        int r_title = 0, g_title = 0, b_title = 0;
        int phase = (frame_counter / 3) % 3;
        if (phase == 0) { r_title=255; g_title=0; b_title=0; }
        else if (phase == 1) { r_title=0; g_title=255; b_title=0; }
        else { r_title=0; g_title=0; b_title=255; }

        if (game_mode == MODE_TENNIS) {
            lcd_puts_color(2, 1, "TENNIS MODE", r_title, g_title, b_title);
        } else if (game_mode == MODE_SQUASH_1P) {
            lcd_puts_color(2, 0, "SQUASH 1P", r_title, g_title, b_title);
        } else {
            lcd_puts_color(2, 0, "SQUASH 2P", r_title, g_title, b_title);
        }
        
        if ((frame_counter / 5) % 2) {
            lcd_puts_color(4, 0, "PRESS 0", 255, 255, 0);
            lcd_puts_color(5, 0, "TO START", 255, 255, 0);
        } else {
            lcd_puts_color(4, 0, "PRESS 0", 255, 0, 0);
            lcd_puts_color(5, 0, "TO START", 255, 0, 0);
        }
    } else if (game_state == STATE_PLAY) {
        /* プレイ中 */
        if (game_mode == MODE_TENNIS) {
            /* テニスゲームロジック（100msecごとに処理） */
            
            /* ラケット操作（100msec間隔で処理） */
            /* P1: キーパッドで2次元移動（input_p1_dirを使用） */
            if (input_p1_dir == 1) {         /* キーパッド1: 上 */
                if (p1_y > 5) p1_y -= 6;
            }
            if (input_p1_dir == 7) {         /* キーパッド7: 下 */
                if (p1_y < 47) p1_y += 6;
            }
            if (input_p1_dir == 4) {         /* キーパッド4: 左 */
                if (p1_x > 5) p1_x -= 6;
            }
            if (input_p1_dir == 5) {         /* キーパッド5: 右 */
                if (p1_x < 40) p1_x += 6;
            }
            /* P2: キーパッドで2次元移動（input_p2_dirを使用） */
            if (input_p2_dir == 0xa) {         /* キーパッドA: 上 */
                if (p2_y > 5) p2_y -= 6;
            }
            if (input_p2_dir == 0xc) {         /* キーパッドC: 下 */
                if (p2_y < 47) p2_y += 6;
            }
            if (input_p2_dir == 6) {           /* キーパッド6: 左 */
                if (p2_x > 50) p2_x -= 6;
            }
            if (input_p2_dir == 0xb) {         /* キーパッドB: 右 */
                if (p2_x < 86) p2_x += 6;
            }
            
            /* ボール移動 */
            ball_x += ball_vx;
            ball_y += ball_vy;

            /* 上下壁との反射 (コートライン y=4, y=59) */
            if (ball_y <= 5) {
                ball_y = 5;
                ball_vy = -ball_vy;
            }
            if (ball_y >= 55) { /* 59 - BALL_SIZE */
                ball_y = 55;
                ball_vy = -ball_vy;
            }

            /* P1ラケットとの衝突判定 */
            if (ball_x <= p1_x + RACKET_WIDTH &&
                ball_x + BALL_SIZE >= p1_x &&
                ball_y + BALL_SIZE >= p1_y &&
                ball_y <= p1_y + RACKET_HEIGHT) {
                ball_x = p1_x + RACKET_WIDTH;
                ball_vx = -ball_vx;
                /* 打ち返し音（短め） */
                buzzer_play(TONE_HIT);
                buzzer_timer = BUZZER_SHORT;
            }

            /* P2ラケットとの衝突判定 */
            if (ball_x + BALL_SIZE >= p2_x &&
                ball_x <= p2_x + RACKET_WIDTH &&
                ball_y + BALL_SIZE >= p2_y &&
                ball_y <= p2_y + RACKET_HEIGHT) {
                ball_x = p2_x - BALL_SIZE;
                ball_vx = -ball_vx;
                /* 打ち返し音（短め） */
                buzzer_play(TONE_HIT);
                buzzer_timer = BUZZER_SHORT;
            }

            /* 得点判定 */
            if (ball_x < 0) {
                /* P2得点 */
                score_p2++;
                ball_x = 46;
                ball_y = 26;
                ball_vx = 3;
                ball_vy = 2;
                /* 得点音（長め） */
                buzzer_play(TONE_SCORE);
                buzzer_timer = BUZZER_LONG;
            }
            if (ball_x > 96 - BALL_SIZE) {
                /* P1得点 */
                score_p1++;
                ball_x = 46;
                ball_y = 26;
                ball_vx = -3;
                ball_vy = 2;
                /* 得点音（長め） */
                buzzer_play(TONE_SCORE);
                buzzer_timer = BUZZER_LONG;
            }

            /* 勝利判定（5点先取） */
            if (score_p1 >= 5 || score_p2 >= 5) {
                game_state = STATE_RESULT;
            }
            
            draw_tennis_game();
        } else {
            /* スカッシュモード（1Pまたは2P） */
            squash_update();
        }
    } else if (game_state == STATE_RESULT) {
        /* 結果画面 */
        if (game_mode == MODE_TENNIS) {
            /* テニス結果画面 */
            lcd_clear_vbuf();
            int phase = (frame_counter / 2) % 2;
            lcd_puts_color(1, 0, "============", 255, 255, 255);
            if (phase) {
                lcd_puts_color(2, 0, " GAME OVER! ", 255, 0, 0);
            } else {
                lcd_puts_color(2, 0, " GAME OVER! ", 255, 255, 255);
            }
            lcd_puts_color(3, 0, "============", 255, 255, 255);
            
            /* 勝者表示 */
            if (score_p1 > score_p2) {
                lcd_puts_color(4, 0, " WINNER: P1 ", 0, 255, 0);
            } else {
                lcd_puts_color(4, 0, " WINNER: P2 ", 255, 128, 0);
            }
            
            /* スコア表示 */
            char result_str[12];
            result_str[0] = 'S'; result_str[1] = 'C'; result_str[2] = 'O';
            result_str[3] = 'R'; result_str[4] = 'E'; result_str[5] = ':';
            result_str[6] = '0' + score_p1;
            result_str[7] = '-';
            result_str[8] = '0' + score_p2;
            result_str[9] = '\0';
            lcd_puts_color(6, 1, result_str, 255, 255, 0);
            lcd_puts_color(7, 0, "0+1:RESET", 0, 255, 255);
        } else {
            /* スカッシュ結果画面 */
            draw_result_squash(sq_score);
        }
    }
    lcd_sync_vbuf();
}

/*
 * メイン関数
 */
void main() {
    
    volatile int *iob_ptr = (int *)0xff14;
    
    *iob_ptr = 1; lcd_wait(500000);
    *iob_ptr = 2; lcd_wait(500000);
    *iob_ptr = 3; lcd_wait(500000);
    *iob_ptr = 4; lcd_wait(500000);
    *iob_ptr = 5; lcd_wait(500000);
    *iob_ptr = 6; lcd_wait(500000);
    *iob_ptr = 0; lcd_wait(500000);

    while (1) {
        if (game_state == STATE_INIT) {
            /* LCD初期化 */
            lcd_init();
            game_state = STATE_SELECT;
            cursor = 0;
            rotary_prev = rotary_read();  /* ロータリーエンコーダの初期値を保存 */
        } else if (game_state == STATE_SELECT) {
            /* モード選択画面 */
            int btn3 = btn_check_3();  /* UP */
            int btn2 = btn_check_2();  /* DOWN */
            int btn0 = btn_check_0();  /* DECIDE */

            /* ボタン3: カーソル上移動（エッジ検出） */
            if (btn3 && !btn3_prev) {
                if (cursor > 0) {
                    cursor--;
                    led_blink();
                }
            }
            /* ボタン2: カーソル下移動（エッジ検出） */
            if (btn2 && !btn2_prev) {
                if (cursor < 2) {
                    cursor++;
                    led_blink();
                }
            }

            /* ロータリーエンコーダでカーソル移動 */
            int rotary_val = rotary_read();
            int diff = rotary_val - rotary_prev;
            
            /* ラップアラウンド対策: 差分が大きすぎる場合は逆方向に補正 */
            if (diff > 128) diff -= 256;       /* 例: 2 - 254 = -252 → +4 に補正 */
            else if (diff < -128) diff += 256; /* 例: 254 - 2 = 252 → -4 に補正 */
            
            /* 反時計回り（値が増える）→ カーソル下に移動 */
            if (diff >= rotary_threshold) {
                if (cursor < 2) {
                    cursor++;
                    led_blink();
                }
                rotary_prev = rotary_val;
            }
            /* 時計回り（値が減る）→ カーソル上に移動 */
            else if (diff <= -rotary_threshold) {
                if (cursor > 0) {
                    cursor--;
                    led_blink();
                }
                rotary_prev = rotary_val;
            }

            /* ボタン0: 決定（エッジ検出） */
            if (btn0 && !btn0_prev) {
                game_mode = cursor;
                game_state = STATE_WAIT;
                led_blink();
            }

            btn0_prev = btn0;
            btn2_prev = btn2;
            btn3_prev = btn3;

        } else if (game_state == STATE_WAIT) {
            /* 待機画面：ボタン0でゲーム開始 */
            int btn0 = btn_check_0();
            int btn1 = btn_check_1();

            /* ボタン0+1同時押し：モード選択に戻る */
            if (btn0 && btn1) {
                game_state = STATE_SELECT;
                cursor = 0;
                rotary_prev = rotary_read();  /* ロータリーエンコーダの値をリセット */
            }
            /* ボタン0のみ：ゲーム開始 */
            else if (btn0 && !btn0_prev) {
                /* ゲーム変数初期化 */
                if (game_mode == MODE_TENNIS) {
                    /* テニスモード初期化 */
                    p1_x = P1_X;
                    p1_y = 24;
                    p2_x = P2_X;
                    p2_y = 24;
                    ball_x = 46;
                    ball_y = 30;
                    ball_vx = 3;
                    ball_vy = 2;
                    score_p1 = 0;
                    score_p2 = 0;
                } else {
                    /* スカッシュモード初期化 */
                    sq_p1_x = 2;       /* 左側に配置 */
                    sq_p1_y = 16;
                    sq_p2_x = 2;       /* 左側に配置（P1の下） */
                    sq_p2_y = 36;
                    sq_ball_x = 20;    /* ボールも左側から開始 */
                    sq_ball_y = 26;
                    sq_ball_vx = 3;    /* 右に向かって発射 */
                    sq_ball_vy = 2;
                    sq_score = 0;
                    sq_lives = 3;
                    sq_turn = 0;       /* P1のターンから開始 */
                    sq_rally = 0;
                }
                game_state = STATE_PLAY;
                led_blink();
            }
            btn0_prev = btn0;

        } else if (game_state == STATE_PLAY) {
            /* プレイ中：入力読み取りのみ（ゲームロジックは割り込みハンドラで処理） */
            /* 入力状態を読み取ってグローバル変数に保存（P1とP2を別々に検出） */
            kypd_scan_both(&input_p1_dir, &input_p2_dir);
            input_btn0 = btn_check_0();
            input_btn1 = btn_check_1();

        } else if (game_state == STATE_RESULT) {
            /* 結果画面：ボタン0+1でモード選択に戻る */
            int btn0 = btn_check_0();
            int btn1 = btn_check_1();

            if (btn0 && btn1) {
                game_state = STATE_SELECT;
                cursor = 0;
                rotary_prev = rotary_read();  /* ロータリーエンコーダの値をリセット */
            }
        }
    }
}

/*
 * モード選択画面の描画
 */
void draw_mode_select(int cursor) {
    lcd_clear_vbuf();

    /* タイトル: レインボーカラー */
    int r, g, b;
    int phase = (frame_counter / 2) % 6;
    switch(phase) {
        case 0: r=255; g=0; b=0; break;
        case 1: r=255; g=255; b=0; break;
        case 2: r=0; g=255; b=0; break;
        case 3: r=0; g=255; b=255; break;
        case 4: r=0; g=0; b=255; break;
        case 5: r=255; g=0; b=255; break;
        default: r=255; g=255; b=255; break;
    }
    lcd_puts_color(0, 0, "== SELECT ==", r, g, b);

    /* 選択肢（カーソル付き） */
    int blink = (frame_counter / 3) % 2;
    int r_sel = blink ? 255 : 255;
    int g_sel = blink ? 255 : 0;
    int b_sel = blink ? 0 : 0; // 黄色 <-> 赤

    if (cursor == 0) {
        lcd_puts_color(2, 0, "> TENNIS   <", r_sel, g_sel, b_sel);
    } else {
        lcd_puts_color(2, 0, "  TENNIS    ", 0, 0, 255);
    }

    if (cursor == 1) {
        lcd_puts_color(3, 0, "> SQUASH 1P<", r_sel, g_sel, b_sel);
    } else {
        lcd_puts_color(3, 0, "  SQUASH 1P ", 0, 0, 255);
    }

    if (cursor == 2) {
        lcd_puts_color(4, 0, "> SQUASH 2P<", r_sel, g_sel, b_sel);
    } else {
        lcd_puts_color(4, 0, "  SQUASH 2P ", 0, 0, 255);
    }

    /* 操作説明 */
    lcd_puts_color(6, 0, "ROTARY/3/2", 0, 255, 255);
    lcd_puts_color(7, 0, "0:DECIDE", 255, 0, 255);
}

/*
 * ボタンチェック関数
 * スイッチのアドレス: 0xff04
 * ビット配置:
 *   bit4: ボタン0
 *   bit5: ボタン1
 *   bit6: ボタン2
 *   bit7: ボタン3
 *   bit0: ボタン4
 *   bit1: ボタン5
 *   bit2: ボタン6
 *   bit3: ボタン7
 */
int btn_check_0() {
    volatile int *sw_ptr = (int *)0xff04;
    return (*sw_ptr & 0x10) ? 1 : 0;
}

int btn_check_1() {
    volatile int *sw_ptr = (int *)0xff04;
    return (*sw_ptr & 0x20) ? 1 : 0;
}

int btn_check_2() {
    volatile int *sw_ptr = (int *)0xff04;
    return (*sw_ptr & 0x40) ? 1 : 0;
}

int btn_check_3() {
    volatile int *sw_ptr = (int *)0xff04;
    return (*sw_ptr & 0x80) ? 1 : 0;
}

/*
 * ロータリーエンコーダ関数
 * アドレス: 0xff10 (ロータリーエンコーダ1, ioa, JB)
 * rte_out[9:2] = カウンタ値（8bit、初期値128）
 * rte_out[1] = 押しボタン
 * rte_out[0] = スライドスイッチ
 */
int rotary_read() {
    volatile int *rte_ptr = (int *)0xff10;
    int val = *rte_ptr;
    /* カウンタ値はbit9:2にあるので右シフトして取り出す */
    return (val >> 2) & 0xff;
}

/*
 * キーパッドスキャン関数
 * アドレス: 0xff18 (cs6, ioc)
 * 下位4bitを出力、上位4bitを入力として使用
 * 戻り値: 押されているキー (0-9, A-F) または -1 (何も押されていない)
 */
void tiny_wait(int n) { for (volatile int i = 0; i < n; i++); }

int kypd_scan() {
    volatile int *ioc_ptr = (int *)0xff18;
    unsigned char raw;

    /* row0: キー 1, 4, 7, 0 をスキャン */
    *ioc_ptr = 0x07; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) return 0x1;
    if ((raw & 0x40) == 0) return 0x4;
    if ((raw & 0x20) == 0) return 0x7;
    if ((raw & 0x10) == 0) return 0x0;

    /* row1: キー 2, 5, 8, F をスキャン */
    *ioc_ptr = 0x0b; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) return 0x2;
    if ((raw & 0x40) == 0) return 0x5;
    if ((raw & 0x20) == 0) return 0x8;
    if ((raw & 0x10) == 0) return 0xf;

    /* row2: キー 3, 6, 9, E をスキャン */
    *ioc_ptr = 0x0d; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) return 0x3;
    if ((raw & 0x40) == 0) return 0x6;
    if ((raw & 0x20) == 0) return 0x9;
    if ((raw & 0x10) == 0) return 0xe;

    /* row3: キー A, B, C, D をスキャン */
    *ioc_ptr = 0x0e; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) return 0xa;
    if ((raw & 0x40) == 0) return 0xb;
    if ((raw & 0x20) == 0) return 0xc;
    if ((raw & 0x10) == 0) return 0xd;

    return -1; /* 何も押されていない */
}

/*
 * 両プレイヤーの入力を同時にスキャンする関数
 * P1: 1=上, 4=左, 5=右, 7=下
 * P2: A=上, 6=左, B=右, C=下
 * 各行をスキャンして両方のプレイヤーの入力を検出
 */
void kypd_scan_both(volatile int *p1_dir, volatile int *p2_dir) {
    volatile int *ioc_ptr = (int *)0xff18;
    unsigned char raw;
    // 一時変数を用意（初期値は入力なし）
    int temp_p1 = -1;
    int temp_p2 = -1;
    /* row0: キー 1, 4, 7, 0 をスキャン（P1の上・左・下） */
    *ioc_ptr = 0x07; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) temp_p1 = 1;  /* 上 */
    if ((raw & 0x40) == 0) temp_p1 = 4;  /* 左 */
    if ((raw & 0x20) == 0) temp_p1 = 7;  /* 下 */
    /* row1: キー 2, 5, 8, F をスキャン（P1の右） */
    *ioc_ptr = 0x0b; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x40) == 0) temp_p1 = 5;  /* 右 */
    /* row2: キー 3, 6, 9, E をスキャン（P2の左） */
    *ioc_ptr = 0x0d; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x40) == 0) temp_p2 = 6;  /* 左 */
    /* row3: キー A, B, C, D をスキャン（P2の上・右・下） */
    *ioc_ptr = 0x0e; tiny_wait(300);
    raw = (unsigned char)(*ioc_ptr & 0xff);
    if ((raw & 0x80) == 0) temp_p2 = 0xa;  /* 上 */
    if ((raw & 0x40) == 0) temp_p2 = 0xb;  /* 右 */
    if ((raw & 0x20) == 0) temp_p2 = 0xc;  /* 下 */
    // 【重要】スキャンが全て終わってから、結果をグローバル変数に反映する
    *p1_dir = temp_p1;
    *p2_dir = temp_p2;

    tiny_wait(100);
}

/*
 * LED関数
 */
void led_set(int data) {
    volatile int *led_ptr = (int *)0xff08;
    *led_ptr = data;
}

void led_blink() {
    led_set(0xf);               /* Turn on */
    for (int i = 0; i < 100000; i++);   /* Wait */
    led_set(0x0);               /* Turn off */
}

/*
 * ブザー関数
 * アドレス: 0xff14 (cs5, iob)
 * mode: 1-13 で音階を指定（1=C, 8=G, 13=高いC）
 *       0 で音を止める
 */
void buzzer_play(int mode) {
    volatile int *iob_ptr = (int *)0xff14;
    *iob_ptr = mode;
}

void buzzer_stop() {
    volatile int *iob_ptr = (int *)0xff14;
    *iob_ptr = 0;
}

/*
 * LCD関数
 */
unsigned char lcd_vbuf[64][96];

void lcd_wait(int n) {
    for (int i = 0; i < n; i++);
}

void lcd_cmd(unsigned char cmd) {
    volatile int *lcd_ptr = (int *)0xff0c;
    *lcd_ptr = cmd;
    lcd_wait(1000);
}

void lcd_data(unsigned char data) {
    volatile int *lcd_ptr = (int *)0xff0c;
    *lcd_ptr = 0x100 | data;
    lcd_wait(200);
}

void lcd_pwr_on() {
    volatile int *lcd_ptr = (int *)0xff0c;
    *lcd_ptr = 0x200;
    lcd_wait(700000);
}

void lcd_init() {
    lcd_pwr_on();   /* Display power ON */
    lcd_cmd(0xa0);  /* Remap & color depth */
    lcd_cmd(0x20);
    lcd_cmd(0x15);  /* Set column address */
    lcd_cmd(0);
    lcd_cmd(95);
    lcd_cmd(0x75);  /* Set row address */
    lcd_cmd(0);
    lcd_cmd(63);
    lcd_cmd(0xaf);  /* Display ON */
}

void lcd_set_vbuf_pixel(int row, int col, int r, int g, int b) {
    r >>= 5; g >>= 5; b >>= 6;
    lcd_vbuf[row][col] = ((r << 5) | (g << 2) | (b << 0)) & 0xff;
}

void lcd_clear_vbuf() {
    for (int row = 0; row < 64; row++)
        for (int col = 0; col < 96; col++)
            lcd_vbuf[row][col] = 0;
}

void lcd_sync_vbuf() {
    for (int row = 0; row < 64; row++)
        for (int col = 0; col < 96; col++)
            lcd_data(lcd_vbuf[row][col]);
}

void lcd_putc(int y, int x, int c) {
    for (int v = 0; v < 8; v++)
        for (int h = 0; h < 8; h++)
            if ((font8x8[(c - 0x20) * 8 + h] >> v) & 0x01)
                lcd_set_vbuf_pixel(y * 8 + v, x * 8 + h, 0, 255, 0);
}

void lcd_puts(int y, int x, char *str) {
    for (int i = 0; str[i] != '\0' && (x + i) < 12; i++) {
        if (str[i] >= 0x20 && str[i] <= 0x7f) {
            lcd_putc(y, x + i, str[i]);
        }
    }
}

void lcd_putc_color(int y, int x, int c, int r, int g, int b) {
    for (int v = 0; v < 8; v++)
        for (int h = 0; h < 8; h++)
            if ((font8x8[(c - 0x20) * 8 + h] >> v) & 0x01)
                lcd_set_vbuf_pixel(y * 8 + v, x * 8 + h, r, g, b);
}

void lcd_puts_color(int y, int x, char *str, int r, int g, int b) {
    for (int i = 0; str[i] != '\0' && (x + i) < 12; i++) {
        if (str[i] >= 0x20 && str[i] <= 0x7f) {
            lcd_putc_color(y, x + i, str[i], r, g, b);
        }
    }
}

/*
 * テニスモード描画関数
 */

/* コート描画 */
void draw_court_lines() {
    /* 外枠 */
    for(int x=4; x<=91; x++) {
        lcd_set_vbuf_pixel(4, x, 255,255,255);
        lcd_set_vbuf_pixel(59, x, 255,255,255);
    }
    for(int y=4; y<=59; y++) {
        lcd_set_vbuf_pixel(y, 4, 255,255,255);
        lcd_set_vbuf_pixel(y, 91, 255,255,255);
    }
    /* サービスライン */
    for(int y=16; y<=47; y++) {
        lcd_set_vbuf_pixel(y, 24, 255,255,255);
        lcd_set_vbuf_pixel(y, 71, 255,255,255);
    }
    /* センターライン (点線) */
    for(int x=24; x<=71; x+=2) {
         lcd_set_vbuf_pixel(32, x, 255,255,255);
    }
    /* ネット */
    for(int y=2; y<=61; y+=2) {
        lcd_set_vbuf_pixel(y, 48, 180,180,180);
    }
}

/* ラケット描画 */
void draw_racket(int x, int y, int r, int g, int b) {
    for (int dy = 0; dy < RACKET_HEIGHT; dy++) {
        for (int dx = 0; dx < RACKET_WIDTH; dx++) {
            int py = y + dy;
            int px = x + dx;
            /* 境界チェック */
            if (px >= 0 && px < 96 && py >= 0 && py < 64) {
                int type = RACKET_PATTERN[dy][dx];
                if (type == 1) { /* フレーム */
                    lcd_set_vbuf_pixel(py, px, r, g, b);
                } else if (type == 2) { /* ガット (白半透明 -> 灰色) */
                    lcd_set_vbuf_pixel(py, px, 100, 100, 100);
                }
            }
        }
    }
}

/* ボール描画 */
void draw_ball(int x, int y) {
    for (int dy = 0; dy < BALL_SIZE; dy++) {
        for (int dx = 0; dx < BALL_SIZE; dx++) {
            int py = y + dy;
            int px = x + dx;
            /* 境界チェック */
            if (px >= 0 && px < 96 && py >= 0 && py < 64) {
                lcd_set_vbuf_pixel(py, px, 255, 255, 0); /* 黄色 */
            }
        }
    }
}

/* テニス画面全体描画 */
void draw_tennis_game() {
    lcd_clear_vbuf();
    
    /* 背景色（濃緑）で塗りつぶし */
    for (int y = 0; y < 64; y++) {
        for (int x = 0; x < 96; x++) {
            lcd_set_vbuf_pixel(y, x, 0, 100, 0);
        }
    }

    /* コートライン描画 */
    draw_court_lines();
    
    /* ラケット描画 */
    draw_racket(p1_x, p1_y, 0, 255, 0);     /* P1: 緑 */
    draw_racket(p2_x, p2_y, 255, 128, 0);   /* P2: オレンジ */
    
    /* ボール描画 */
    draw_ball(ball_x, ball_y);
    
    /* スコア表示 */
    char score_str[8];
    score_str[0] = '0' + score_p1;
    score_str[1] = '-';
    score_str[2] = '0' + score_p2;
    score_str[3] = '\0';
    lcd_puts_color(0, 5, score_str, 255, 255, 255);
}

/*
 * スカッシュモード描画関数
 */

/* 背景描画（暗い青緑） */
void draw_squash_background() {
    for (int y = 0; y < 56; y++) {
        for (int x = 0; x < 96; x++) {
            lcd_set_vbuf_pixel(y, x, 0, 40, 60);
        }
    }
}

/* 壁描画（水色） */
void draw_squash_walls() {
    /* 上壁 */
    for (int y = 0; y < WALL_THICKNESS; y++)
        for (int x = 0; x < 96; x++)
            lcd_set_vbuf_pixel(y, x, 0, 180, 255);
    
    /* 下壁 */
    for (int y = 52; y < 56; y++)
        for (int x = 0; x < 96; x++)
            lcd_set_vbuf_pixel(y, x, 0, 180, 255);
    
    /* 右壁 */
    for (int y = 0; y < 56; y++)
        for (int x = 92; x < 96; x++)
            lcd_set_vbuf_pixel(y, x, 0, 180, 255);
}

/* ラケット描画（テニスと同じパターン） */
void draw_squash_racket(int x, int y, int r, int g, int b) {
    for (int dy = 0; dy < RACKET_HEIGHT; dy++) {
        for (int dx = 0; dx < RACKET_WIDTH; dx++) {
            int py = y + dy;
            int px = x + dx;
            /* 境界チェック */
            if (px >= 0 && px < 96 && py >= 0 && py < 56) {
                int type = RACKET_PATTERN[dy][dx];
                if (type == 1) { /* フレーム */
                    lcd_set_vbuf_pixel(py, px, r, g, b);
                } else if (type == 2) { /* ガット (灰色) */
                    lcd_set_vbuf_pixel(py, px, 100, 100, 100);
                }
            }
        }
    }
}

/* ボール描画（白色、4x4） */
void draw_squash_ball(int x, int y) {
    for (int dy = 0; dy < BALL_SIZE; dy++) {
        for (int dx = 0; dx < BALL_SIZE; dx++) {
            int px = x + dx;
            int py = y + dy;
            if (px >= 0 && px < 96 && py >= 0 && py < 56) {
                lcd_set_vbuf_pixel(py, px, 255, 255, 255);
            }
        }
    }
}

/* スコア表示 */
void draw_squash_score(int score) {
    lcd_putc_color(7, 0, 'S', 0, 255, 0);
    lcd_putc_color(7, 1, ':', 0, 255, 0);
    lcd_putc_color(7, 2, '0' + (score / 100) % 10, 0, 255, 0);
    lcd_putc_color(7, 3, '0' + (score / 10) % 10, 0, 255, 0);
    lcd_putc_color(7, 4, '0' + score % 10, 0, 255, 0);
}

/* 残機表示 */
void draw_lives(int lives) {
    lcd_putc_color(7, 6, 'L', 255, 0, 0);
    lcd_putc_color(7, 7, ':', 255, 0, 0);
    for (int i = 0; i < 3; i++) {
        if (i < lives) {
            lcd_putc_color(7, 8 + i, '*', 255, 0, 0); /* 残機あり */
        } else {
            lcd_putc_color(7, 8 + i, '-', 100, 100, 100); /* 失った残機 */
        }
    }
}

/* ターン表示（点滅） */
void draw_turn_indicator(int turn, int frame) {
    int blink = (frame / 3) % 2;
    if (turn == 0) {
        /* P1のターン */
        if (blink) {
            lcd_puts_color(0, 0, "P1", 0, 255, 0);
        } else {
            lcd_puts_color(0, 0, "P1", 255, 255, 0);
        }
        lcd_puts_color(0, 2, " <", 255, 255, 0);
    } else {
        /* P2のターン */
        if (blink) {
            lcd_puts_color(0, 0, "P2", 255, 128, 0);
        } else {
            lcd_puts_color(0, 0, "P2", 255, 255, 0);
        }
        lcd_puts_color(0, 2, " <", 255, 255, 0);
    }
}

/* スカッシュ画面全体描画 */
void draw_squash_game() {
    lcd_clear_vbuf();
    
    /* 背景描画 */
    draw_squash_background();
    
    /* 壁描画 */
    draw_squash_walls();
    
    /* ラケット描画（テニスと同じ形状） */
    /* 現在のターンのプレイヤーは明るく、そうでない方は暗く表示 */
    if (sq_turn == 0) {
        draw_squash_racket(sq_p1_x, sq_p1_y, 0, 255, 0);      /* P1: 緑（明るい） */
        if (game_mode == MODE_SQUASH_2P) {
            draw_squash_racket(sq_p2_x, sq_p2_y, 128, 64, 0); /* P2: 暗いオレンジ */
        }
    } else {
        draw_squash_racket(sq_p1_x, sq_p1_y, 0, 128, 0);      /* P1: 暗い緑 */
        if (game_mode == MODE_SQUASH_2P) {
            draw_squash_racket(sq_p2_x, sq_p2_y, 255, 128, 0);/* P2: オレンジ（明るい） */
        }
    }
    
    /* ボール描画 */
    draw_squash_ball(sq_ball_x, sq_ball_y);
    
    /* ターン表示 */
    if (game_mode == MODE_SQUASH_2P) {
        draw_turn_indicator(sq_turn, frame_counter);
    }
    
    /* スコア・残機表示 */
    draw_squash_score(sq_score);
    draw_lives(sq_lives);
}

/* スカッシュモード割り込みハンドラ処理 */
void squash_update() {
    /* プレイヤー移動 */
    squash_move_players();
    
    /* ボール移動 */
    sq_ball_x += sq_ball_vx;
    sq_ball_y += sq_ball_vy;
    
    /* 上壁との反射 */
    if (sq_ball_y <= WALL_THICKNESS) {
        sq_ball_y = WALL_THICKNESS;
        sq_ball_vy = -sq_ball_vy;
        buzzer_play(TONE_HIT);
        buzzer_timer = BUZZER_SHORT;
    }
    
    /* 下壁との反射 */
    if (sq_ball_y >= 52 - BALL_SIZE) {
        sq_ball_y = 52 - BALL_SIZE;
        sq_ball_vy = -sq_ball_vy;
        buzzer_play(TONE_HIT);
        buzzer_timer = BUZZER_SHORT;
    }
    
    /* 右壁との反射 */
    if (sq_ball_x >= 92 - BALL_SIZE) {
        sq_ball_x = 92 - BALL_SIZE;
        sq_ball_vx = -sq_ball_vx;
        buzzer_play(TONE_HIT);
        buzzer_timer = BUZZER_SHORT;
    }
    
    /* ラケットとの当たり判定（テニスと同様のロジック） */
    /* P1ラケットとの衝突判定 */
    if (sq_ball_vx < 0) {  /* ボールが左に向かっている時のみ判定 */
        if (sq_ball_x <= sq_p1_x + RACKET_WIDTH &&
            sq_ball_x + BALL_SIZE >= sq_p1_x &&
            sq_ball_y + BALL_SIZE >= sq_p1_y &&
            sq_ball_y <= sq_p1_y + RACKET_HEIGHT) {
            sq_ball_x = sq_p1_x + RACKET_WIDTH;
            sq_ball_vx = -sq_ball_vx;
            sq_score++;
            sq_rally++;
            /* 2Pモードでターン切り替え */
            if (game_mode == MODE_SQUASH_2P) {
                sq_turn = 1;  /* P2のターンに */
            }
            buzzer_play(TONE_HIT);
            buzzer_timer = BUZZER_SHORT;
        }
    }
    
    /* P2ラケットとの衝突判定（2Pモード時） */
    if (game_mode == MODE_SQUASH_2P && sq_ball_vx < 0) {
        if (sq_ball_x <= sq_p2_x + RACKET_WIDTH &&
            sq_ball_x + BALL_SIZE >= sq_p2_x &&
            sq_ball_y + BALL_SIZE >= sq_p2_y &&
            sq_ball_y <= sq_p2_y + RACKET_HEIGHT) {
            sq_ball_x = sq_p2_x + RACKET_WIDTH;
            sq_ball_vx = -sq_ball_vx;
            sq_score++;
            sq_rally++;
            /* ターン切り替え */
            sq_turn = 0;  /* P1のターンに */
            buzzer_play(TONE_HIT);
            buzzer_timer = BUZZER_SHORT;
        }
    }
    
    /* 左端到達（ミス判定） */
    if (sq_ball_x < 0) {
        /* ミス */
        sq_lives--;
        if (sq_lives <= 0) {
            game_state = STATE_RESULT;
        } else {
            /* ボールリセット（左側から再スタート） */
            sq_ball_x = 20;
            sq_ball_y = 26;
            sq_ball_vx = 3;
            sq_ball_vy = 2;
            sq_rally = 0;
            sq_turn = 0;  /* P1のターンに戻す */
        }
        buzzer_play(TONE_SCORE);
        buzzer_timer = BUZZER_LONG;
    }
    
    /* 画面描画 */
    draw_squash_game();
}

/* プレイヤー移動処理 */
void squash_move_players() {
    int move_speed = 6;  /* テニスと同じ移動速度 */
    
    /* P1移動（1Pモードでは常に、2Pモードではターンに関係なく移動可能） */
    if (input_p1_dir == 1) {  /* キーパッド1: 上 */
        if (sq_p1_y > WALL_THICKNESS) sq_p1_y -= move_speed;
    }
    if (input_p1_dir == 7) {  /* キーパッド7: 下 */
        if (sq_p1_y < 52 - RACKET_HEIGHT) sq_p1_y += move_speed;
    }
    if (input_p1_dir == 4) {  /* キーパッド4: 左 */
        if (sq_p1_x > 0) sq_p1_x -= move_speed;
    }
    if (input_p1_dir == 5) {  /* キーパッド5: 右 */
        /* 1Pモードでは広く、2Pモードでは左半分 */
        if (sq_p1_x < 80) sq_p1_x += move_speed;
    }
    
    /* P2移動（2Pモード時） */
    if (game_mode == MODE_SQUASH_2P) {
        if (input_p2_dir == 0xa) {  /* キーパッドA: 上 */
            if (sq_p2_y > WALL_THICKNESS) sq_p2_y -= move_speed;
        }
        if (input_p2_dir == 0xc) {  /* キーパッドC: 下 */
            if (sq_p2_y < 52 - RACKET_HEIGHT) sq_p2_y += move_speed;
        }
        if (input_p2_dir == 6) {    /* キーパッド6: 左 */
            if (sq_p2_x > 0) sq_p2_x -= move_speed;
        }
        if (input_p2_dir == 0xb) {  /* キーパッドB: 右 */
            if (sq_p2_x < 80) sq_p2_x += move_speed;
        }
    }
}

/* スカッシュ結果画面 */
void draw_result_squash(int score) {
    lcd_clear_vbuf();
    lcd_puts_color(1, 0, "============", 255, 255, 255);
    lcd_puts_color(2, 0, " GAME OVER! ", 255, 0, 0);
    lcd_puts_color(3, 0, "============", 255, 255, 255);
    
    lcd_putc_color(5, 0, 'S', 0, 255, 0);
    lcd_putc_color(5, 1, 'C', 0, 255, 0);
    lcd_putc_color(5, 2, 'O', 0, 255, 0);
    lcd_putc_color(5, 3, 'R', 0, 255, 0);
    lcd_putc_color(5, 4, 'E', 0, 255, 0);
    lcd_putc_color(5, 5, ':', 0, 255, 0);
    lcd_putc_color(5, 6, '0' + (score / 100) % 10, 0, 255, 0);
    lcd_putc_color(5, 7, '0' + (score / 10) % 10, 0, 255, 0);
    lcd_putc_color(5, 8, '0' + score % 10, 0, 255, 0);
    
    lcd_puts_color(7, 0, "0+1:RESET", 0, 255, 255);
}

