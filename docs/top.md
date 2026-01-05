# top.v - MIPSシステム トップレベルモジュール解説

## 概要

`top.v` は、MIPSプロセッサを中心としたシステム全体を構成するトップレベルVerilogファイルです。FPGA（Zynq-7000）上で動作し、CPU、メモリ、タイマー、SPI、各種I/Oを統合しています。

---

## モジュール構成

```
┌─────────────────────────────────────────────────────────────┐
│                      fpga_top                               │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │  MIPS   │  │   mem   │  │  timer  │  │   spi   │        │
│  │  CPU    │  │ (RAM)   │  │(100ms)  │  │(Display)│        │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │
│       ↕            ↕            ↕            ↕              │
│  ┌──────────────────────────────────────────────────┐      │
│  │              内部バス / アドレスデコード           │      │
│  └──────────────────────────────────────────────────┘      │
│       ↕            ↕            ↕            ↕              │
│   [btn/sw]      [led]        [lcd]      [ioa/iob]          │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. fpga_top モジュール（メインモジュール）

### 入出力ポート

| ポート名     | 方向   | ビット幅 | 説明                         |
|-------------|--------|---------|------------------------------|
| clk_125mhz  | input  | 1       | 125MHz入力クロック            |
| sw          | input  | 4       | スイッチ入力（4ビット）         |
| btn         | input  | 4       | ボタン入力（4ビット）           |
| led         | output | 4       | LED出力（4ビット）             |
| lcd         | output | 8       | LCD/ディスプレイ制御出力        |
| ioa         | input  | 8       | 汎用入力ポートA               |
| iob         | output | 8       | 汎用出力ポートB               |

### クロック生成

```verilog
always @ (posedge clk_125mhz)
    if (reset)  clk_62p5mhz <= 1;
    else        clk_62p5mhz <= ~clk_62p5mhz;
```

- 125MHzクロックを2分周して **62.5MHz** のCPUクロックを生成
- CPUは62.5MHzで動作、メモリは125MHzで動作

### リセット回路

```verilog
assign reset = btn[0] & btn[1];
```

- **btn[0]** と **btn[1]** を同時押しでリセット発生

### メモリマップ（アドレスデコード）

| チップセレクト | アドレス条件           | デバイス                    |
|--------------|----------------------|---------------------------|
| cs0          | dataadr < 0xff00     | メインメモリ（RAM）         |
| cs1          | dataadr == 0xff04    | スイッチ/ボタン入力（読み込み専用）|
| cs2          | dataadr == 0xff08    | LED出力                    |
| cs3          | dataadr == 0xff0c    | LCD/SPI出力                |
| cs4          | dataadr == 0xff10    | IOA入力                    |

### 各デバイスの接続

```verilog
// MIPSプロセッサ（@62.5MHz）
mips mips (clk_62p5mhz, reset, pc, instr, {7'b0000000, irq}, memwrite, 
    memtoregM, swc, byteen, dataadr, writedata, readdata, 1'b1, 1'b1);

// メモリ（@125MHz）
mem mem (clk_125mhz, reset, cs0 & memwrite, pc[15:2], dataadr[15:2], instr, 
    readdata0, writedata, byteen);

// タイマー（@62.5MHz）
timer timer (clk_62p5mhz, reset, irq);

// SPI（@62.5MHz）
spi spi (clk_62p5mhz, reset, cs3 && memwrite, writedata[9:0], lcd);
```

### I/Oレジスタ

| アドレス | 読み込み                      | 書き込み            |
|---------|------------------------------|-------------------|
| 0xff04  | {24'h0, btn[3:0], sw[3:0]}   | -                 |
| 0xff08  | -                            | led[3:0]          |
| 0xff0c  | -                            | SPI/LCDデータ      |
| 0xff10  | {24'h0, ioa[7:0]}            | -                 |

---

## 2. timer モジュール（100msタイマー）

### 機能

- 62.5MHzクロックで動作する **100ミリ秒** 周期タイマー
- カウンタが6,250,000に達すると割り込み信号（irq）を発生

### 動作原理

```verilog
assign irq = (counter == 23'd6250000);

always @ (posedge clk or posedge reset)
    if (reset)                      counter <= 0;
    else if (counter < 23'd6250000) counter <= counter + 1;
    else                            counter <= 0;
```

- **計算**: 62,500,000 Hz ÷ 6,250,000 = 10 Hz → 100ms周期
- 23ビットカウンタを使用（2^23 = 8,388,608 > 6,250,000）

---

## 3. mem モジュール（メモリ）

### 仕様

| 項目        | 値                    |
|------------|----------------------|
| ワード幅    | 32ビット              |
| 容量       | 16,384ワード（64KB）   |
| 動作クロック | 125MHz               |
| ポート構成  | デュアルポート（命令/データ）|

### バイトイネーブル

```verilog
assign byte0 = byteen[0] ? writedata[ 7: 0] : readdata[ 7: 0];
assign byte1 = byteen[1] ? writedata[15: 8] : readdata[15: 8];
assign byte2 = byteen[2] ? writedata[23:16] : readdata[23:16];
assign byte3 = byteen[3] ? writedata[31:24] : readdata[31:24];
```

- バイト単位での書き込みをサポート（lb, sb命令対応）
- byteen[n] = 1 の場合、該当バイトを書き込み
- byteen[n] = 0 の場合、既存データを保持

### メモリ初期化

```verilog
initial $readmemh("program.dat", RAM, 0, 16383);
```

- `program.dat` ファイルからプログラムをロード（16進数形式）

---

## 4. spi モジュール（SPI出力ドライバ）

### 機能

- 8ビットSPIマスターコントローラ
- OLEDディスプレイなどの制御に使用

### 入出力

| 信号名 | 方向   | ビット幅 | 説明              |
|-------|--------|---------|------------------|
| clk   | input  | 1       | 62.5MHzクロック   |
| reset | input  | 1       | リセット          |
| start | input  | 1       | 転送開始          |
| din   | input  | 10      | 入力データ        |
| dout  | output | 8       | SPI出力信号       |

### データフォーマット（din[9:0]）

| ビット | 意味                                      |
|-------|------------------------------------------|
| [9]   | 電源制御（1: ディスプレイ電源ON）           |
| [8]   | DC（0: コマンド, 1: データ）               |
| [7:0] | 送信データ（8ビット）                      |

### 出力信号（dout[7:0]）

| ビット | 信号名  | 説明                 |
|-------|--------|---------------------|
| [7]   | pmoden | ディスプレイ電源イネーブル |
| [6]   | vccen  | VCC電源イネーブル       |
| [5]   | res_   | リセット（負論理）       |
| [4]   | dc_    | データ/コマンド選択     |
| [3]   | sck    | SPIクロック            |
| [2]   | -      | 未使用                |
| [1]   | sdo    | SPIデータ出力          |
| [0]   | cs_    | チップセレクト（負論理） |

### 状態遷移

```
SPI_WAIT → SPI_START → SPI_TRANS → SPI_STOP → SPI_WAIT
   ↑                                              │
   └──────────────────────────────────────────────┘
```

| 状態       | 動作                          |
|-----------|------------------------------|
| SPI_WAIT  | 待機状態、start信号待ち        |
| SPI_START | CS_をアサート、準備           |
| SPI_TRANS | 8ビットシリアル転送            |
| SPI_STOP  | CS_をデアサート、完了          |

### SPIクロック周波数

```verilog
`define SPI_FREQDIV 25  /* 62.5MHz / 2 / 25 = 1.25MHz */
```

- 62.5MHz ÷ 2 ÷ 25 = **1.25MHz** のSPIクロックを生成

---

## 使用例（Cプログラムから）

```c
// スイッチ読み込み
volatile int *sw_ptr = (int *)0xff04;
int sw_val = *sw_ptr & 0xff;

// LED書き込み
volatile int *led_ptr = (int *)0xff08;
*led_ptr = 0x0f;  // 全LED点灯

// IOA読み込み
volatile int *ioa_ptr = (int *)0xff10;
int ioa_val = *ioa_ptr & 0xff;

// SPI/LCD書き込み
volatile int *lcd_ptr = (int *)0xff0c;
*lcd_ptr = 0x100 | data;  // データ送信（DC=1）
*lcd_ptr = 0x000 | cmd;   // コマンド送信（DC=0）
*lcd_ptr = 0x200;         // 電源ON
```

---

## 履歴

| 日付       | 変更内容                                   |
|-----------|-------------------------------------------|
| 2013-07-04 | 初版作成                                   |
| 2013-10-07 | バイトイネーブル追加                         |
| 2016-06-03 | ターゲットをSpartan-3ANからZynq-7000に変更   |
| 2019-08-30 | 100msecタイマー追加                         |
| 2024-07-21 | SPI出力ドライバ追加                         |

