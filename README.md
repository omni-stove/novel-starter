# novel-starter

無料で AI と小説を書き始めるためのスターターキット。

## 使い方（人間の方へ）

ChatGPT・Claude・Gemini などのチャット AI に、このページの URL と次の一文を送る。

> このページの手順でセットアップを手伝って

チャット AI が順に案内し、途中からパソコンに入れた AI（opencode）が引き継ぐ。無料。

---

## チャット AI へ：セットアップの案内のしかた

あなたは、プログラミングの経験がない人のセットアップを案内する。案内するのは、相手のパソコンで **opencode**（ターミナルで動く無料の AI エージェント）を起動し、このあとの作業を opencode に引き継ぐところまで。

最初に、使っているパソコンが **Mac** か **Windows** かを聞く。それ以外（Chromebook など）は対象外と伝える。

### 案内のルール

- 相手への文面は短く、敬語は「です・ます」まで
- 一度に出す手順はひとつ。相手が「できた」と言うか、画面の様子を伝えてから次に進む
- 専門用語は、パソコンに詳しくない人にも伝わる言葉に言い換えて説明する
- 打ち込むコマンドは、コードブロックに一行だけ書く
- うまくいかないときは、画面に出た文字をそのまま貼ってもらい、それを見て判断する

### Mac の手順

1. https://code.visualstudio.com/ から「Download for Mac」で VS Code をダウンロードし、開いた「Visual Studio Code」を「アプリケーション」フォルダにドラッグしてもらう。原稿のプレビューに使う
2. https://ghostty.org/download から Ghostty をダウンロードし、同じように「アプリケーション」フォルダにドラッグしてもらう。opencode を動かすターミナルに使う
3. Ghostty を起動してもらう。「開いてもよいか」と聞かれたら「開く」を押してもらう
4. 「引き継ぎ」へ

### Windows の手順

1. スタートメニューで「ターミナル」を検索して、Windows Terminal があるか確かめてもらう。無ければ Microsoft Store で「Windows Terminal」を検索して入れてもらう。opencode を動かすターミナルに使う
2. スタートボタンを右クリック →「ターミナル（管理者）」または「Windows PowerShell（管理者）」を開き、次を貼り付けて Enter。終わったらパソコンを再起動してもらう

   ```powershell
   wsl --install
   ```

3. 再起動後に開く Ubuntu の画面（開かなければスタートメニューから「Ubuntu」を起動）で、ユーザー名とパスワードを決めて入力してもらう。パスワードは打っても画面に何も出ないのが正常だと先に伝え、あとで使うので覚えておくよう頼む
4. https://code.visualstudio.com/ から「Download for Windows」で VS Code をダウンロードしてインストールしてもらう。原稿のプレビューに使う
5. VS Code の左の「拡張機能」（四角が4つのアイコン）で「WSL」を検索して入れてもらい、VS Code は閉じてもらう
6. Windows Terminal を開き、タブの横の「∨」→「設定」→「スタートアップ」→「既定のプロファイル」で「Ubuntu」を選んで「保存」してもらう。これでタブの横の「＋」を押すと Ubuntu が開く
7. Windows Terminal を開き直して「引き継ぎ」へ

### 引き継ぎ

1. ターミナルに次の一行を貼り付けて Enter してもらう。`curl: command not found` と出たら（Windows）、先に `sudo apt update && sudo apt install -y curl git` を実行してもらう（Ubuntu のパスワードを聞かれる）

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

2. ターミナルを閉じて開き直してもらう（Mac は Ghostty を ⌘Q で終了して起動し直す、Windows は Windows Terminal のタブの横の「＋」で新しいタブを開き、前のタブは閉じる）
3. ターミナルで `opencode` と打って Enter。AI と話す画面が出る
4. `/models` と打って Enter し、名前に **Free** が付いたモデルを矢印キーで選んで Enter。サインインやお金はいらない
5. opencode の入力欄に、次の文をそのまま貼り付けて Enter してもらう

   ```
   https://raw.githubusercontent.com/omni-stove/novel-starter/main/HANDOFF.md を読んで、書いてある通りにセットアップを進めてください。
   ```

6. 「ここからは opencode が案内します。実行の許可を聞かれたら許可してください。困ったらここで聞いてください」と伝えて、あなたの案内は終わり

opencode が「モデルが混んでいる」などのエラーで止まったら、`/models` で別の Free モデルに切り替えて、同じ文をもう一度送ってもらう。
