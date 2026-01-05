# UI担当者向け仕様書

**ゲーム名:** テニス＆スカッシュゲーム  
**担当:** UI実装

---

## 1. ハードウェア仕様

### 1.1 LCD画面仕様

| 項目 | 値 |
|------|-----|
| 解像度 | 96 × 64 ピクセル |
| 色深度 | 8bit (RGB332: R3-G3-B2) |
| フォント | 8 × 8 ピクセル (ASCII) |
| 文字表示可能範囲 | 12列 × 8行 |

### 1.2 座標系

```
(0,0)────────────────────────────(95,0)
│                                      │
│     LCD座標系                        │
│     ・X: 0〜95 (左→右)             │
│     ・Y: 0〜63 (上→下)             │
│                                      │
(0,63)────────────────────────(95,63)
```

### 1.3 文字座標系

```
文字単位: (x, y) = (列, 行)
・x: 0〜11 (12列)
・y: 0〜7  (8行)

ピクセル変換: 
・pixel_x = x * 8
・pixel_y = y * 8
```

---

## 2. 使用可能なAPI関数

### 2.1 LCD関数一覧

| 関数名 | 引数 | 説明 |
|--------|------|------|
| `lcd_init()` | なし | LCD初期化（起動時に1回呼ぶ） |
| `lcd_clear_vbuf()` | なし | VBUFをクリア（全画面黒） |
| `lcd_sync_vbuf()` | なし | VBUFの内容をLCDに反映 |
| `lcd_putc(y, x, c)` | y:行(0-7), x:列(0-11), c:文字 | 文字を表示 |
| `lcd_puts(y, x, str)` | y:行, x:列, str:文字列 | 文字列を表示 |
| `lcd_set_vbuf_pixel(row, col, r, g, b)` | row:Y座標, col:X座標, r/g/b:色(0-255) | ピクセル単位で描画 |

### 2.2 描画の流れ

```c
// 毎フレームの描画処理
lcd_clear_vbuf();           // 1. バッファクリア
// ... 描画処理 ...         // 2. 各要素を描画
lcd_sync_vbuf();            // 3. LCDに反映
```

**重要:** `lcd_sync_vbuf()` は割り込みハンドラ内で呼ばれるため、描画処理は `lcd_clear_vbuf()` と `lcd_sync_vbuf()` の間に行う。

---

## 3. 画面一覧と設計

### 3.1 画面遷移図

```
┌─────────────┐     0ボタン     ┌─────────────┐
│             │───────────────→│             │
│  モード選択  │                 │   待機画面   │
│             │←───────────────│             │
└─────────────┘   FPGA 0+1     └──────┬──────┘
       │                               │
       │                           0ボタン
       │                               ▼
       │                       ┌─────────────┐
       │                       │             │
       │                       │  プレイ中    │
       │                       │             │
       │                       └──────┬──────┘
       │                               │
       │                           勝敗確定
       │                               ▼
       │                       ┌─────────────┐
       │        FPGA 0+1       │             │
       └───────────────────────│  結果画面   │
                               │             │
                               └─────────────┘
```

---

### 3.2 モード選択画面

#### レイアウト

```
行0: "== SELECT =="
行1: (空行)
行2: "> TENNIS"     または "  TENNIS"
行3: "  SQUASH 1P"  または "> SQUASH 1P"
行4: "  SQUASH 2P"  または "> SQUASH 2P"
行5: (空行)
行6: "5:UP 4:DOWN"
行7: "0:DECIDE"
```

#### 実装例

```c
void draw_mode_select(int cursor) {
    lcd_clear_vbuf();
    lcd_puts(0, 0, "== SELECT ==");
    
    // カーソル表示
    lcd_puts(2, 0, cursor == 0 ? "> TENNIS" : "  TENNIS");
    lcd_puts(3, 0, cursor == 1 ? "> SQUASH1P" : "  SQUASH1P");
    lcd_puts(4, 0, cursor == 2 ? "> SQUASH2P" : "  SQUASH2P");
    
    lcd_puts(6, 0, "5:UP 4:DOWN");
    lcd_puts(7, 0, "0:DECIDE");
}
```

---

### 3.3 テニスモード - プレイ画面

#### 画面コンセプト
Pongのような抽象的な画面ではなく、実際のテニスコートを模したトップビュー（上空視点）のリッチなUIとする。
緑色のコート、白いライン、ネット、そして形状を持ったラケットを描画する。

#### 画面レイアウト (96×64ピクセル)

```
     0         24        48        72        95
   0 ┌──────────────────────────────────────┐
     │ __________________  .  ______________│
     │|   (サービス)     | . |              |
     │|      エリア      | . |              |
   16│|__________________| . |______________|
     │                   | . |              │
   32│-------------------+ . +--------------│← センターライン
     │ __________________| . |______________│
     │|                  | . |              |
   48│|                  | . |              |
     │|__________________| . |______________|
     │                   | . |              │
   64 └──────────────────┴─┴────────────────┘
                         ↑ネット
      P1ラケット        ボール        P2ラケット
      (スプライト)                  (スプライト)
```

#### 要素の定義

| 要素 | 描画内容 | 座標・範囲 | 色 (RGB) |
|------|----------|------------|----------|
| **コート全体** | 背景色 | 全画面 | 濃緑 (0, 100, 0) |
| **コートライン** | 枠線・区画線 | 外枠: (4,4)-(91,59)<br>サービスライン: x=24, x=71<br>センターライン: y=32 | 白 (255,255,255) |
| **ネット** | 縦の点線 | x=47,48 | 灰色 (180,180,180) |
| **ラケット** | グリップとヘッドを持つ形状 | P1: 左側, P2: 右側<br>サイズ: 8×12 px 程度 | フレーム: プレイヤー色<br>ガット: 白半透明 |
| **ボール** | 円形（ドット絵） | 4×4 px | テニスボール黄 (255, 255, 0) |
| **スコア** | 数値 | 画面上部中央 | 白 (255,255,255) |

#### ビットマップパターン例 (8x12 ラケット)

```
(上向きの例、実際は90度回転して使用)
..####..
.##..##.
.##..##.
.##..##.
.##..##.
.##..##.
..####..
...##...
...##...
...##...
...##...
...##...
```
※ `#`: フレーム色, `.`: 背景またはガット色

#### 実装例

```c
// ラケット（簡易ビットマップ 8x12）
// 1:フレーム, 2:ガット, 0:透過
// 実際には90度回転させて使用するか、描画時に座標変換する
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

void draw_court_lines() {
    // 処理負荷軽減のため、塗りつぶしは行わずラインのみ描画する例
    // 外枠
    for(int x=4; x<=91; x++) {
        lcd_set_vbuf_pixel(4, x, 255,255,255);
        lcd_set_vbuf_pixel(59, x, 255,255,255);
    }
    for(int y=4; y<=59; y++) {
        lcd_set_vbuf_pixel(y, 4, 255,255,255);
        lcd_set_vbuf_pixel(y, 91, 255,255,255);
    }
    // サービスライン
    for(int y=16; y<=47; y++) {
        lcd_set_vbuf_pixel(y, 24, 255,255,255);
        lcd_set_vbuf_pixel(y, 71, 255,255,255);
    }
    // センターライン
    for(int x=24; x<=71; x+=2) { // 点線風
         lcd_set_vbuf_pixel(32, x, 255,255,255);
    }
    // ネット
    for(int y=2; y<=61; y+=2) {
        lcd_set_vbuf_pixel(y, 48, 200,200,200);
    }
}

void draw_racket_sprite(int x, int y, int r, int g, int b) {
    // パターンを描画（ここではそのまま描画しているが、向きに合わせて回転が必要）
    for(int dy=0; dy<12; dy++) {
        for(int dx=0; dx<8; dx++) {
            int px = x + dx;
            int py = y + dy;
            if (px < 0 || px >= 96 || py < 0 || py >= 64) continue;
            
            int type = RACKET_PATTERN[dy][dx];
            if (type == 1) { // フレーム
                lcd_set_vbuf_pixel(py, px, r, g, b);
            } else if (type == 2) { // ガット
                lcd_set_vbuf_pixel(py, px, 100, 100, 100);
            }
        }
    }
}

void draw_tennis_game(int p1_y, int p2_y, int ball_x, int ball_y, 
                       int score_p1, int score_p2) {
    lcd_clear_vbuf();
    
    // 背景色（全画面塗りつぶしは重い場合、省略可）
    // draw_fill_screen(0, 50, 0); 
    
    draw_court_lines();
    
    draw_racket_sprite(2, p1_y, 0, 255, 0);   // P1
    draw_racket_sprite(86, p2_y, 255, 0, 0);  // P2
    
    // ボール (黄色)
    lcd_set_vbuf_pixel(ball_y, ball_x, 255, 255, 0);
    lcd_set_vbuf_pixel(ball_y+1, ball_x, 255, 255, 0);
    lcd_set_vbuf_pixel(ball_y, ball_x+1, 255, 255, 0);
    lcd_set_vbuf_pixel(ball_y+1, ball_x+1, 255, 255, 0);

    // スコア表示 (上部中央)
    char score_str[8];
    score_str[0] = '0' + score_p1;
    score_str[1] = '-';
    score_str[2] = '0' + score_p2;
    score_str[3] = '\0';
    lcd_puts(0, 5, score_str);
}
```

---

### 3.4 スカッシュモード - プレイ画面

#### 画面コンセプト
壁打ちテニス（スカッシュ）を模したゲーム画面。**テニスモードと同じラケット形状**を使用し、
右側の壁に向かってボールを打ち込み、跳ね返ってくるボールを打ち返す。
**2Pモードではターン制**を採用し、交互にボールを打ち返す。
インドアコートを模した暗めの背景に、壁を強調した配色でプレイエリアを明確にする。

#### ゲームルール
- **壁の配置:** 上・下・右の3方向に壁あり。左端は開放（ミス判定領域）
- **反射:** ボールは壁に当たると反射する
- **ラケット:** テニスモードと同じ8×12ピクセルのラケット形状を使用
- **当たり判定:** テニスモードと同様、ラケットの矩形領域との衝突判定
- **ターン制（2Pモード）:** ボールを打ち返すと次のプレイヤーのターンに切り替わる
- **初期配置:** 両プレイヤーを画面左側に配置
- **ミス:** 打ち返せないと残機減少。残機0でゲームオーバー
- **スコア:** 打ち返すたびに+1点

#### 画面レイアウト (96×64ピクセル)

```
     0    8   16   24   32   40   48   56   64   72   80   88   95
   0 ┌────────────────────────────────────────────────────────────┐
     │ P1 <  (ターン表示: 2Pモード時)                            │← 行0
   4 │███████████████████████████████████████████████████████████│← 上壁(4px)
     │ ┌──┐                                                    ███│
     │ │P1│   (ラケット形状)                                   ███│← 右壁(4px)
     │ │  │                    ●                               ███│
     │ └──┘                  (ボール)                          ███│
     │                                                         ███│
     │ ┌──┐                                                    ███│
     │ │P2│   (2Pモード時、暗く表示=待機中)                    ███│
     │ └──┘                                                    ███│
  52 │███████████████████████████████████████████████████████████│← 下壁(4px)
  56 │ S:000  L:***                                              │← UI領域
  64 └────────────────────────────────────────────────────────────┘
     ↑
     左端は開放（ミス判定領域）
```

#### 座標系の定義

| 領域 | X範囲 | Y範囲 | 説明 |
|------|-------|-------|------|
| ターン表示 | 0-31 | 0-7 | 現在のターンを表示（2Pモード時） |
| 上壁 | 0-95 | 0-3 | ボール反射 |
| 下壁 | 0-95 | 52-55 | ボール反射 |
| 右壁 | 92-95 | 0-55 | ボール反射 |
| プレイ領域 | 0-91 | 4-51 | ラケット・ボール移動可能範囲 |
| UI領域 | 0-95 | 56-63 | スコア・残機表示 |
| ミス判定線 | x<0 | 4-51 | ボールがここを通過するとミス |

#### 要素の定義

| 要素 | 描画内容 | 座標・範囲 | サイズ | 色 (RGB) |
|------|----------|------------|--------|----------|
| **背景** | 塗りつぶし | 全画面 | 96×56 px | 暗い青緑 (0,40,60) |
| **上壁** | 塗りつぶし | y:0-3, x:0-95 | 96×4 px | 水色 (0,180,255) |
| **下壁** | 塗りつぶし | y:52-55, x:0-95 | 96×4 px | 水色 (0,180,255) |
| **右壁** | 塗りつぶし | y:0-55, x:92-95 | 4×56 px | 水色 (0,180,255) |
| **P1ラケット** | ラケット（テニスと同形状） | (p1_x, p1_y) | 8×12 px | ターン時:緑(0,255,0) / 待機時:暗い緑(0,128,0) |
| **P2ラケット** | ラケット（テニスと同形状） | (p2_x, p2_y) | 8×12 px | ターン時:オレンジ(255,128,0) / 待機時:暗いオレンジ(128,64,0) |
| **ボール** | 円形ドット | (ball_x, ball_y) | 4×4 px | 白 (255,255,255) |
| **ターン表示** | "P1 <" or "P2 <" | 行0, 列0-3 | 文字 | 点滅 |
| **スコア** | "S:XXX" | 行7, 列0-4 | 文字 | 緑 (0,255,0) |
| **残機** | "L:***" | 行7, 列6-10 | 文字/記号 | 赤 (255,0,0) |

#### ラケットパターン（テニスと共通）(8×12ピクセル)

```
ラケット形状:
..####..   ← フレーム上部
.#○○○○#.   ← フレーム + ガット
.#○○○○#.
.#○○○○#.
.#○○○○#.
..####..   ← フレーム下部
...##...   ← グリップ
...##...
...##...
...##...
...##...
...##...

# = フレーム色（プレイヤー色）
○ = ガット（灰色）
. = 透過
```

```c
/* ラケットパターン (1:フレーム, 2:ガット, 0:透過) - テニスと共通 */
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
```

#### 移動範囲とパラメータ

| パラメータ | 値 | 説明 |
|------------|-----|------|
| RACKET_WIDTH | 8 | ラケット幅（テニスと共通） |
| RACKET_HEIGHT | 12 | ラケット高さ（テニスと共通） |
| BALL_SIZE | 4 | ボールサイズ |
| WALL_THICKNESS | 4 | 壁の厚さ |
| MOVE_SPEED | 6 | 1フレームあたりの移動量（テニスと同じ） |
| BALL_SPEED_X | 3 | ボールX方向速度 |
| BALL_SPEED_Y | 2 | ボールY方向速度 |
| P1_INIT_X | 2 | P1の初期X座標（左側） |
| P1_INIT_Y | 16 | P1の初期Y座標 |
| P2_INIT_X | 2 | P2の初期X座標（左側、P1の下） |
| P2_INIT_Y | 36 | P2の初期Y座標 |

#### 1Pモードと2Pモードの違い

| 項目 | 1Pモード | 2Pモード |
|------|----------|----------|
| プレイヤー数 | 1人 | 2人 |
| ターン制 | なし（常にP1） | あり（交互に切り替わる） |
| 当たり判定 | P1のみ | P1またはP2（打ち返した方がターン切替） |
| ターン表示 | なし | "P1 <" または "P2 <" を点滅表示 |
| ラケット明度 | 常に明るい | ターン中のプレイヤーは明るく、待機中は暗く |
| スコア | 共通 | 共通（協力モード） |
| 残機 | 共有 | 共有 |
| 操作 | キーパッド1,4,5,7 | P1:1,4,5,7 / P2:A,6,B,C |

#### 実装例

```c
#define WALL_THICKNESS  4
#define RACKET_WIDTH    8    /* テニスと共通 */
#define RACKET_HEIGHT   12   /* テニスと共通 */
#define BALL_SIZE       4

/* スカッシュモード用グローバル変数 */
int sq_p1_x = 2, sq_p1_y = 16;      /* P1座標（左側配置） */
int sq_p2_x = 2, sq_p2_y = 36;      /* P2座標（左側配置） */
int sq_ball_x = 20, sq_ball_y = 26; /* ボール座標（左側から開始） */
int sq_ball_vx = 3, sq_ball_vy = 2; /* ボール速度 */
int sq_score = 0;                    /* スコア */
int sq_lives = 3;                    /* 残機 */
int sq_turn = 0;                     /* 現在のターン (0=P1, 1=P2) */
int sq_rally = 0;                    /* ラリー回数 */

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

/* スコア表示 */
void draw_squash_score(int score) {
    lcd_putc_color(7, 0, 'S', 0, 255, 0);
    lcd_putc_color(7, 1, ':', 0, 255, 0);
    lcd_putc_color(7, 2, '0' + (score / 100) % 10, 0, 255, 0);
    lcd_putc_color(7, 3, '0' + (score / 10) % 10, 0, 255, 0);
    lcd_putc_color(7, 4, '0' + score % 10, 0, 255, 0);
}

/* スカッシュ画面全体描画 */
void draw_squash_game() {
    lcd_clear_vbuf();
    
    /* 背景描画 */
    draw_squash_background();
    
    /* 壁描画 */
    draw_squash_walls();
    
    /* ラケット描画（現在のターンのプレイヤーは明るく表示） */
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
    
    /* ターン表示（2Pモード時のみ） */
    if (game_mode == MODE_SQUASH_2P) {
        draw_turn_indicator(sq_turn, frame_counter);
    }
    
    /* スコア・残機表示 */
    draw_squash_score(sq_score);
    draw_lives(sq_lives);
}
```

#### ゲームロジック実装例

```c
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
    
    /* P1移動（常に操作可能） */
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
        int max_x = (game_mode == MODE_SQUASH_2P) ? 40 : 80;
        if (sq_p1_x < max_x) sq_p1_x += move_speed;
    }
    
    /* P2移動（2Pモード時、常に操作可能） */
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
```

---

### 3.5 待機画面（スタート待ち）

#### 共通レイアウト

```
行0: (空行)
行1: (空行)
行2: "TENNIS MODE"  / "SQUASH 1P" / "SQUASH 2P"
行3: (空行)
行4: "PRESS 0"      (点滅)
行5: "TO START"     (点滅)
行6: (空行)
行7: "0+1:BACK"
```

#### 実装例

```c
void draw_wait_screen(int mode, int frame) {
    lcd_clear_vbuf();
    
    /* モード名表示（レインボーカラー） */
    int r, g, b;
    int phase = (frame / 3) % 3;
    if (phase == 0) { r=255; g=0; b=0; }
    else if (phase == 1) { r=0; g=255; b=0; }
    else { r=0; g=0; b=255; }
    
    if (mode == MODE_TENNIS) {
        lcd_puts_color(2, 1, "TENNIS MODE", r, g, b);
    } else if (mode == MODE_SQUASH_1P) {
        lcd_puts_color(2, 1, "SQUASH 1P", r, g, b);
    } else {
        lcd_puts_color(2, 1, "SQUASH 2P", r, g, b);
    }
    
    /* 点滅するスタート指示 */
    if ((frame / 5) % 2) {
        lcd_puts_color(4, 2, "PRESS 0", 255, 255, 0);
        lcd_puts_color(5, 2, "TO START", 255, 255, 0);
    } else {
        lcd_puts_color(4, 2, "PRESS 0", 255, 0, 0);
        lcd_puts_color(5, 2, "TO START", 255, 0, 0);
    }
    
    lcd_puts_color(7, 1, "0+1:BACK", 0, 255, 255);
}
```

---

### 3.6 結果画面

#### テニスモード結果

```
行0: (空行)
行1: "============"
行2: " GAME OVER! "  (点滅)
行3: "============"
行4: "WINNER: P1"  または "WINNER: P2"
行5: (空行)
行6: "SCORE: 5-3"
行7: "0+1:RESET"
```

#### スカッシュモード結果（1P/2P共通）

```
行0: (空行)
行1: "============"
行2: " GAME OVER! "  (点滅)
行3: "============"
行4: "FINAL SCORE:"
行5: "   999 pts"
行6: (空行)
行7: "0+1:RESET"
```

#### ハイスコア表示（オプション）

```
行0: (空行)
行1: "============"
行2: " GAME OVER! "
行3: "============"
行4: "SCORE: 123"
行5: "HIGH:  456"    ← ハイスコアを超えた場合は "NEW RECORD!"
行6: (空行)
行7: "0+1:RESET"
```

#### 実装例

```c
void draw_result_tennis(int score_p1, int score_p2, int frame) {
    lcd_clear_vbuf();
    lcd_puts_color(1, 0, "============", 255, 255, 255);
    
    /* GAME OVER!を点滅 */
    if ((frame / 2) % 2) {
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
    char score_str[12] = "SCORE: X-X";
    score_str[7] = '0' + score_p1;
    score_str[9] = '0' + score_p2;
    lcd_puts_color(6, 1, score_str, 255, 255, 0);
    
    lcd_puts_color(7, 1, "0+1:RESET", 0, 255, 255);
}

void draw_result_squash(int score, int high_score, int frame) {
    lcd_clear_vbuf();
    lcd_puts_color(1, 0, "============", 255, 255, 255);
    
    /* GAME OVER!を点滅 */
    if ((frame / 2) % 2) {
        lcd_puts_color(2, 0, " GAME OVER! ", 255, 0, 0);
    } else {
        lcd_puts_color(2, 0, " GAME OVER! ", 255, 255, 255);
    }
    
    lcd_puts_color(3, 0, "============", 255, 255, 255);
    
    /* スコア表示 */
    lcd_puts_color(4, 0, "FINAL SCORE:", 0, 255, 0);
    
    /* 3桁スコア表示 */
    char pts_str[12] = "   XXX pts";
    pts_str[3] = '0' + (score / 100) % 10;
    pts_str[4] = '0' + (score / 10) % 10;
    pts_str[5] = '0' + score % 10;
    lcd_puts_color(5, 1, pts_str, 255, 255, 0);
    
    /* ハイスコア表示（オプション） */
    if (score > high_score) {
        lcd_puts_color(6, 0, "NEW RECORD!", 255, 0, 255);
    }
    
    lcd_puts_color(7, 1, "0+1:RESET", 0, 255, 255);
}
```

#### 結果画面エフェクト

```c
/* 勝者演出（テニスモード） */
void draw_winner_effect(int winner, int frame) {
    int phase = frame % 10;
    
    /* 紙吹雪エフェクト */
    for (int i = 0; i < 5; i++) {
        int x = (frame * 7 + i * 19) % 96;
        int y = (frame * 3 + i * 11) % 64;
        int color = (i + frame) % 3;
        if (color == 0) lcd_set_vbuf_pixel(y, x, 255, 0, 0);
        else if (color == 1) lcd_set_vbuf_pixel(y, x, 0, 255, 0);
        else lcd_set_vbuf_pixel(y, x, 0, 0, 255);
    }
}
```

---

## 4. カラーパレット

### 4.1 推奨色

| 用途 | R | G | B | 説明 |
|------|---|---|---|------|
| 背景 | 0 | 0 | 0 | 黒 |
| 文字（標準） | 0 | 255 | 0 | 緑 |
| ボール | 255 | 255 | 255 | 白 |
| プレイヤー1 | 0 | 255 | 0 | 緑 |
| プレイヤー2 | 255 | 0 | 0 | 赤 |
| 壁 | 0 | 0 | 255 | 青 |
| 警告 | 255 | 255 | 0 | 黄 |
| 得点時 | 255 | 0 | 255 | マゼンタ |

### 4.2 RGB332変換

```c
// 24bit RGB → 8bit RGB332 変換（lcd_set_vbuf_pixel内で自動変換）
// R: 3bit (0-7), G: 3bit (0-7), B: 2bit (0-3)
// rgb332 = ((r >> 5) << 5) | ((g >> 5) << 2) | (b >> 6)
```

---

## 5. 実装タスク一覧

### 5.1 必須タスク

| No | タスク | 優先度 | 状態 |
|----|--------|--------|------|
| 1 | モード選択画面の実装 | 高 | ✓ |
| 2 | テニス - ラケット描画関数 | 高 | ✓ |
| 3 | テニス - ボール描画関数 | 高 | ✓ |
| 4 | テニス - コートライン描画 | 高 | ✓ |
| 5 | テニス - スコア表示 | 高 | ✓ |
| 6 | テニス - 結果画面 | 中 | ✓ |
| 7 | スカッシュ - 背景描画関数 | 高 | ✓ |
| 8 | スカッシュ - 壁描画関数 | 高 | ✓ |
| 9 | スカッシュ - ラケット描画（テニスと同形状） | 高 | ✓ |
| 10 | スカッシュ - ボール描画関数 | 高 | ✓ |
| 11 | スカッシュ - スコア表示 | 高 | ✓ |
| 12 | スカッシュ - 残機表示 | 高 | ✓ |
| 13 | スカッシュ - ターン表示 | 高 | ✓ |
| 14 | スカッシュ - 結果画面 | 中 | ✓ |
| 15 | 待機画面の実装 | 中 | ✓ |

### 5.2 スカッシュモード詳細タスク

| No | タスク | 説明 | 状態 |
|----|--------|------|------|
| S1 | draw_squash_background() | 暗い青緑の背景塗りつぶし | ✓ |
| S2 | draw_squash_walls() | 上・下・右壁の描画 | ✓ |
| S3 | draw_squash_racket() | テニスと同じ8x12ラケット描画 | ✓ |
| S4 | draw_squash_ball() | 4x4ボールの描画 | ✓ |
| S5 | draw_squash_score() | S:XXX形式のスコア表示 | ✓ |
| S6 | draw_lives() | L:***形式の残機表示 | ✓ |
| S7 | draw_turn_indicator() | ターン表示（P1 < / P2 <）| ✓ |
| S8 | draw_squash_game() | 全要素を統合した描画関数 | ✓ |
| S9 | squash_update() | ボール移動・衝突判定（テニス同様） | ✓ |
| S10 | squash_move_players() | プレイヤー移動処理 | ✓ |
| S11 | ターン制実装 | 打ち返しでターン切り替え | ✓ |
| S12 | 初期配置変更 | 両プレイヤーを左側に配置 | ✓ |

### 5.3 オプションタスク

| No | タスク | 優先度 | 状態 |
|----|--------|--------|------|
| 15 | オープニングアニメーション | 低 | □ |
| 16 | 得点時エフェクト（+1!表示） | 低 | □ |
| 17 | ミス時画面フラッシュ | 低 | □ |
| 18 | 角度インジケーター表示 | 低 | □ |
| 19 | カウントダウン表示 | 低 | □ |
| 20 | 勝者演出（紙吹雪） | 低 | □ |
| 21 | ハイスコア保存・表示 | 低 | □ |

---

## 6. 注意事項

### 6.1 パフォーマンス

- 割り込みハンドラは **100msecごと** に呼ばれる
- 描画処理はできるだけ軽くする
- `lcd_sync_vbuf()` は全ピクセル (96×64=6144回) の書き込みを行うため重い処理

### 6.2 座標境界チェック

```c
// 描画前に境界チェックを行う
if (x >= 0 && x < 96 && y >= 0 && y < 64) {
    lcd_set_vbuf_pixel(y, x, r, g, b);
}
```

### 6.3 フォント制限

- 使用可能文字: ASCII 0x20〜0x7F (スペース〜DEL)
- 日本語は使用不可
- 数字の動的表示は `'0' + 数値` で変換

---

## 7. デバッグ用関数

```c
// 座標確認用グリッド表示
void draw_debug_grid() {
    // 10ピクセルごとにドットを表示
    for (int y = 0; y < 64; y += 10) {
        for (int x = 0; x < 96; x += 10) {
            lcd_set_vbuf_pixel(y, x, 255, 0, 0);
        }
    }
}

// 画面全体を指定色で塗りつぶし（動作確認用）
void draw_fill_screen(int r, int g, int b) {
    for (int y = 0; y < 64; y++) {
        for (int x = 0; x < 96; x++) {
            lcd_set_vbuf_pixel(y, x, r, g, b);
        }
    }
}
```

---

## 8. 関連ファイル

| ファイル | 説明 |
|----------|------|
| `soft/test.c` | メインプログラム（現在のサンプル実装） |
| `soft/ChrFont0.h` | 8×8ピクセルASCIIフォントデータ |
| `soft/crt0.c` | 起動コード・割り込みハンドラ設定 |

---

## 9. チェックリスト

### 9.1 共通チェック

- [ ] `lcd_init()` を起動時に呼んでいるか
- [ ] 描画は `lcd_clear_vbuf()` で開始しているか
- [ ] 描画完了後に `lcd_sync_vbuf()` を呼んでいるか
- [ ] 座標が画面範囲 (0-95, 0-63) 内か
- [ ] 文字座標が範囲 (0-11, 0-7) 内か
- [ ] ゲーム状態に応じた画面を描画しているか

### 9.2 テニスモードチェック

- [ ] コートラインが正しく描画されるか
- [ ] ラケットスプライトが境界内で描画されるか
- [ ] ボールが上下壁で正しく反射するか
- [ ] スコアが5点で勝敗判定されるか
- [ ] 打ち返し時にブザー音が鳴るか

### 9.3 スカッシュモードチェック

- [ ] 背景が暗い青緑で塗りつぶされるか
- [ ] 壁（上・下・右）が水色で描画されるか
- [ ] 左端が開放（壁なし）になっているか
- [ ] **ラケット形状がテニスと同じ8×12ピクセルで表示されるか**
- [ ] **両プレイヤーが左側に配置されて開始するか**
- [ ] プレイヤーが2次元移動できるか
- [ ] ボールが3方向の壁で正しく反射するか
- [ ] **ラケットとの当たり判定がテニスと同様に動作するか**
- [ ] ミス時に残機が減少するか
- [ ] スコアが3桁表示されるか
- [ ] 残機が表示されるか
- [ ] **2Pモードでターン表示（P1 < または P2 <）が点滅するか**
- [ ] **2Pモードでボールを打ち返すとターンが切り替わるか**
- [ ] **2Pモードで現在のターンのラケットが明るく、待機中は暗く表示されるか**
- [ ] 2Pモードで両プレイヤーが操作できるか

### 9.4 画面遷移チェック

- [ ] モード選択 → 待機画面の遷移
- [ ] 待機画面 → プレイ中の遷移（ボタン0）
- [ ] 待機画面 → モード選択への戻り（ボタン0+1）
- [ ] プレイ中 → 結果画面の遷移（勝敗/ゲームオーバー）
- [ ] 結果画面 → モード選択への戻り（ボタン0+1）

