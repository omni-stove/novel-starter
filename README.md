# novel-starter

無料で AI と小説を書き始めるためのスターターキット。

## 使い方（人間の方へ）

ChatGPT・Claude・Gemini などのチャット AI に、このページの URL だけを送る。

チャット AI が順に案内し、途中からパソコンに入れた AI（opencode）が引き継ぐ。無料。

---

## チャット AI へ：セットアップの案内のしかた

このページの URL が送られてきたら、それがセットアップの依頼。すぐに案内を始める。

プログラミングの経験がない人のセットアップを、相手のパソコンで **opencode**（ターミナルで動く無料の AI エージェント）を起動して引き継ぐところまで案内する。最初に **Mac** か **Windows** かを聞く（それ以外は対象外）。

文面は短く、敬語は「です・ます」まで。手順は一度にひとつ出し、相手の返事を待ってから次へ。

### Mac

1. 最初から入っている「ターミナル」を開いてもらう（セットアップの間だけ使う）
2. 「引き継ぎ」へ

### Windows

1. Windows Terminal が無ければ Microsoft Store で入れてもらう
2. 管理者の PowerShell で `wsl --install` を実行し、再起動してもらう
3. 開いた Ubuntu でユーザー名とパスワードを決めてもらう（パスワードはあとで使う）
4. Windows Terminal の既定のプロファイルを Ubuntu にしてもらい、開き直して「引き継ぎ」へ

### 引き継ぎ

1. ターミナルで opencode を入れてもらう。Windows で curl が無ければ先に `sudo apt update && sudo apt install -y curl git`

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

2. ターミナルを開き直して `opencode` を起動し、`/models` で名前に **Free** が付いたモデルを選んでもらう
3. 次の文をそのまま送ってもらう

   ```
   https://raw.githubusercontent.com/omni-stove/novel-starter/main/HANDOFF.md を読んで、書いてある通りにセットアップを進めてください。
   ```

4. 「ここからは opencode が案内します。実行の許可を聞かれたら許可してください」と伝えて終わり

opencode が「モデルが混んでいる」などで止まったら、`/models` で別の Free モデルに替えて同じ文を送り直してもらう。
