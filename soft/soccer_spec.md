# サッカーゲーム仕様書

## 概要
2人対戦のシンプルなサッカーゲーム。ボールを保持しながら相手ゴール（画面端）まで運ぶ。

---

## 使用機器

### ハードウェア
- **LCD**: 96x64 ピクセル（OLEDディスプレイ）
- **キーパッド**: 4x4マトリクスキーパッド（0-9, A-F）
- **ブザー**: 音階再生可能（1-13: C〜高いC）
- **LED**: 4bit LED（フィードバック用）
- **ロータリーエンコーダ**: メニュー選択用
- **ボタン**: btn0〜btn3（決定・キャンセル等）

### メモリマップ
| アドレス | 用途 |
|----------|------|
| 0xff04 | スイッチ/ボタン入力 |
| 0xff08 | LED出力 |
| 0xff0c | LCD制御 |
| 0xff10 | ロータリーエンコーダ |
| 0xff14 | ブザー出力 |
| 0xff18 | キーパッド |

---

## 入力操作

### Player 1（左側スタート、ゴール: 右端）
| 操作 | キー |
|------|------|
| 上移動 | 1 |
| 下移動 | 7 |
| 左移動 | 4 |
| 右移動 | 5 |

### Player 2（右側スタート、ゴール: 左端）
| 操作 | キー |
|------|------|
| 上移動 | A |
| 下移動 | C |
| 左移動 | 6 |
| 右移動 | B |

### システム操作
| 操作 | キー |
|------|------|
| 決定/スタート | btn0 |
| モード選択に戻る | btn0 + btn1 同時押し |
| カーソル上 | btn3 / ロータリー時計回り |
| カーソル下 | btn2 / ロータリー反時計回り |

---

## ゲームルール

### 基本ルール
- **プレイヤー数**: 2人
- **勝利条件**: 先に3点を取ったプレイヤーの勝ち
- **得点方法**: ボールを保持した状態で相手側の画面端に到達
  - P1のゴール: 右端（P1がボール保持で右端到達 → P1得点）
  - P2のゴール: 左端（P2がボール保持で左端到達 → P2得点）

### ボールの挙動
- ゲーム開始時、ボールは画面中央に配置（最初に取った方が保持）
- ボールは単体では移動しない（プレイヤーが保持して移動）
- ボール保持者と相手プレイヤーが**衝突**すると、ボールが相手に渡る

### 移動速度
- **通常移動速度**: 6（テニス・スカッシュと同じ）
- **ボール保持時**: 4（通常の約70%、ボールを持つと遅くなる）

### 無敵時間
- ボールを奪取された後、**約1秒間（10フレーム）は再奪取されない**
- 無敵時間中は視覚的に**点滅表示**

---

## 画面構成

```
+--------------------------------------------------+
|         SCORE: P1 [0] - [0] P2                   |
|                                                  |
|  P1●                                        P2   |
|  [■]                                       [□]  |
|                                                  |
|                                                  |
+--------------------------------------------------+
  ↑                                            ↑
左端(P2のゴール)                         右端(P1のゴール)
```

### 画面要素
- **フィールド**: 96x56 ピクセル（下8ピクセルはスコア表示）
- **プレイヤー1**: PLAYER_PATTERNで描画（緑色）
- **プレイヤー2**: PLAYER_PATTERNで描画（オレンジ色）
- **ボール**: 4x4ピクセルの円（白または黄色）
- **スコア表示**: 画面下部に両者のスコアを表示

### フィールド境界
- **上端**: y=0 で移動制限（画面外に出られない）
- **下端**: y=48 で移動制限（スコア表示領域に入れない）
- **左右端**: ゴールラインとして機能

---

## 衝突判定

### プレイヤー同士の衝突（ボール奪取）
```c
#define COLLISION_THRESHOLD 12  /* プレイヤーサイズ8 + マージン */

// 無敵時間でない場合のみ衝突判定
if (invincible_timer <= 0) {
    int dx = p1_x - p2_x;
    int dy = p1_y - p2_y;
    if (dx < 0) dx = -dx;
    if (dy < 0) dy = -dy;

    if (dx < COLLISION_THRESHOLD && dy < COLLISION_THRESHOLD) {
        // ボールの所有権が相手に移る
        ball_owner = (ball_owner == PLAYER1) ? PLAYER2 : PLAYER1;
        // 奪取された側に無敵時間を付与
        invincible_timer = INVINCIBLE_DURATION;
        buzzer_play(TONE_TACKLE);
        buzzer_timer = BUZZER_SHORT;
    }
}
```

### ゴール判定
```c
#define LEFT_GOAL_LINE   0
#define RIGHT_GOAL_LINE  88  // 96 - PLAYER_SIZE

if (ball_owner == PLAYER1 && p1_x >= RIGHT_GOAL_LINE) {
    p1_score++;
    buzzer_play(TONE_GOAL);
    buzzer_timer = BUZZER_LONG;
    reset_positions();
}
if (ball_owner == PLAYER2 && p2_x <= LEFT_GOAL_LINE) {
    p2_score++;
    buzzer_play(TONE_GOAL);
    buzzer_timer = BUZZER_LONG;
    reset_positions();
}
```

---

## 効果音

| イベント | 音階 | 長さ |
|----------|------|------|
| ゲーム開始 | 13 (高いC) | 5フレーム |
| ボール奪取（タックル） | 8 (G) | 2フレーム |
| ゴール | 13 (高いC) | 5フレーム |
| 勝利 | メロディ（複数音） | - |

---

## ゲームフロー

```
[モード選択画面]
  - TENNIS
  - SQUASH 1P
  - SQUASH 2P
  - SOCCER    ← 追加
     ↓ btn0で決定
[待機画面]
  - "SOCCER MODE" 表示
  - "PRESS 0 TO START" 点滅
     ↓ btn0でスタート
[初期化]
  - P1: 左側 (x=10, y=28)
  - P2: 右側 (x=78, y=28)
  - ボール: 画面中央 (x=46, y=28)
  - ボール所有者: なし（最初に触れた方）
  - スコア: 0-0
     ↓
[ゲームループ] (100msec割り込み)
  ├─ 入力処理（kypd_scan_both）
  ├─ 移動処理
  │    └─ 保持者は速度低下 (6→4)
  ├─ 無敵時間カウントダウン
  ├─ ボール取得判定（所有者なしの場合）
  ├─ 衝突判定（無敵でなければボール移動）
  ├─ ゴール判定
  │    └─ 得点 → 効果音 → リセット
  ├─ 勝利判定（3点先取）
  │    └─ 勝利 → 勝利画面へ
  └─ 描画
       └─ 無敵時間中は点滅
     ↓
[勝利画面]
  - "P1 WIN!" または "P2 WIN!"
  - 最終スコア表示
  - btn0+btn1でモード選択に戻る
```

---

## 定数定義

```c
/* サッカーモード定数 */
#define MODE_SOCCER     3           /* ゲームモード番号 */
#define PLAYER_SIZE     8           /* プレイヤーサイズ */
#define BALL_SIZE       4           /* ボールサイズ */
#define NORMAL_SPEED    6           /* 通常移動速度 */
#define HOLDER_SPEED    4           /* ボール保持時速度（約70%） */
#define COLLISION_THRESHOLD 12      /* 衝突判定距離 */
#define INVINCIBLE_DURATION 10      /* 無敵時間（フレーム数、約1秒） */
#define WINNING_SCORE   3           /* 勝利得点 */
#define LEFT_GOAL_LINE  0           /* 左ゴールライン */
#define RIGHT_GOAL_LINE 88          /* 右ゴールライン */
#define FIELD_TOP       0           /* フィールド上端（移動制限あり） */
#define FIELD_BOTTOM    48          /* フィールド下端（56 - PLAYER_SIZE） */

/* ブザー設定 */
#define TONE_START      13          /* 開始音 */
#define TONE_TACKLE     8           /* タックル音 */
#define TONE_GOAL       13          /* ゴール音 */
#define BUZZER_SHORT    2           /* 短い音（フレーム数） */
#define BUZZER_LONG     5           /* 長い音（フレーム数） */
```

---

## 変数定義

```c
/* サッカーモード用変数 */
int soccer_p1_x, soccer_p1_y;       /* P1座標 */
int soccer_p2_x, soccer_p2_y;       /* P2座標 */
int soccer_ball_x, soccer_ball_y;   /* ボール座標（所有者に追従） */
int soccer_ball_owner;              /* ボール所有者 (0=なし, 1=P1, 2=P2) */
int soccer_p1_score;                /* P1スコア */
int soccer_p2_score;                /* P2スコア */
int soccer_invincible;              /* 無敵中のプレイヤー (0=なし, 1=P1, 2=P2) */
int soccer_invincible_timer;        /* 無敵時間カウンタ */

#define NO_OWNER    0
#define PLAYER1     1
#define PLAYER2     2
```

---

## 描画関数

```c
void draw_soccer_game();            /* サッカー画面全体描画 */
void draw_soccer_player(int x, int y, int r, int g, int b, int blink);
                                    /* プレイヤー描画（点滅対応） */
void draw_soccer_ball(int x, int y);/* ボール描画 */
void draw_soccer_score(int p1, int p2);
                                    /* スコア表示 */
void draw_result_soccer(int p1, int p2);
                                    /* 結果画面 */
void soccer_update();               /* ゲームロジック更新 */
void soccer_move_players();         /* プレイヤー移動処理 */
void soccer_reset_positions();      /* ポジションリセット */
```

---

## 実装優先度

1. **Phase 1: 基本機能**
   - モード選択に SOCCER 追加
   - プレイヤー2人の表示・移動
   - ボールの表示（所有者に追従）

2. **Phase 2: コア機能**
   - ボール取得判定（最初の接触）
   - 衝突によるボール奪取
   - ゴール判定・得点
   - 勝利判定

3. **Phase 3: 追加機能**
   - 移動速度差（保持者減速）
   - 無敵時間・点滅表示
   - 効果音

4. **Phase 4: 演出**
   - ゴール時の演出
   - 勝利画面
