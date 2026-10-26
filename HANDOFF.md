# opencode へ：セットアップの引き継ぎ

あなたは、プログラミングの経験がない人の、AI で小説を書く環境のセットアップを引き継いだ。相手はターミナル（Mac は Ghostty、Windows は Windows Terminal で開いた WSL の Ubuntu）で opencode を動かし、この画面であなたと話している。

コマンドはすべてあなたが実行する。相手に打ってもらうのは GitHub へのログインだけ。各ステップの前にこれから何をするかを、終わったら結果を、パソコンに詳しくない人にも伝わる言葉で一言で伝える。文面は短く、敬語は「です・ます」まで。コマンドが失敗したら、出力を読んで原因を直し、もう一度実行する。

## git を用意する

`git --version` を実行する。出なければ次を実行する。

- Mac：`xcode-select --install` を実行し、「出てきたウィンドウで『インストール』を押して、終わったら教えてください」と頼む。終わったら `git --version` で確かめる
- Linux（WSL）：`sudo apt update && sudo apt install -y git curl`。パスワードを聞かれたら、Ubuntu を入れたときに決めたパスワードを相手にターミナルへ打ってもらう

`git config --global user.name` が空なら、相手にペンネームなど好きな名前を聞いて `git config --global user.name "<名前>"` を設定する。`git config --global user.email` が空なら、メールアドレスは聞かずに `git config --global user.email "<名前>@users.noreply.github.com"` を設定する。

## キットを取ってきて gh を入れる

```sh
git clone https://github.com/omni-stove/novel-starter.git ~/.novel-starter || git -C ~/.novel-starter pull --ff-only
sh ~/.novel-starter/install-gh.sh
```

## GitHub にログインしてもらう

`~/.local/bin/gh auth status` でログイン済みなら次へ。

まだなら、相手に GitHub のアカウントがあるか聞く。無ければ https://github.com/signup で無料で作ってもらう（メールアドレスとパスワードを決めるだけ、と伝える）。

そのあと、こう頼む。

> 1. 新しいターミナルを開く（Mac は Ghostty で ⌘N、Windows は Windows Terminal のタブの横の「＋」）
> 2. 次の一行を貼り付けて Enter
>
>    ```
>    ~/.local/bin/gh auth login --web --hostname github.com --git-protocol https
>    ```
>
> 3. 質問には Enter。出てきた8文字のコードを、開いたブラウザに貼り付けて「Authorize」
> 4. 「Logged in as …」と出たら、ここに戻って「できた」と送る

「できた」と言われたら `~/.local/bin/gh auth status` で確かめる。

## 道具を入れる

```sh
sh ~/.novel-starter/setup.sh
```

## 作品のフォルダを作る

相手に、これから書く作品の仮の名前を聞く（あとで変えられると伝える）。その名前から英小文字・数字・ハイフンだけのフォルダ名を決める。

次に、作品の置き方を相手に選んでもらう。

> 1. **いくつも書く**：作品を並べる棚を作る。あとから作品を足しやすい（おすすめ）
> 2. **この作品だけ**：この作品専用のフォルダを作る

1 なら（`~/novels` がもうあれば `new-repo.sh` を飛ばす）：

```sh
sh ~/.novel-starter/new-repo.sh ~/novels
sh ~/.novel-starter/new-work.sh ~/novels/src/<フォルダ名>
```

2 なら：

```sh
sh ~/.novel-starter/new-repo.sh ~/novels/<フォルダ名>
sh ~/.novel-starter/new-work.sh ~/novels/<フォルダ名>
```

## 作品のフォルダに移ってもらう

`new-work.sh` が開いた VS Code のウィンドウは原稿のプレビュー用。開かなかったら、VS Code の「ファイル」→「フォルダーを開く」で `~/novels`（2 なら `~/novels/<フォルダ名>`）を開いてもらう（Windows では WSL につないだウィンドウで開く）。

相手にこう伝えて、あなたの役目は終わり。`<作品の置き場所>` は 1 なら `~/novels`、2 なら `~/novels/<フォルダ名>` に置き換える。

> セットアップ完了です。
> 1. 新しいターミナルを開く（Mac は Ghostty で ⌘N、Windows は Windows Terminal のタブの横の「＋」）
> 2. 次の一行を貼り付けて Enter
>
>    ```
>    cd <作品の置き場所> && opencode
>    ```
>
> 3. 「書きたい話があります」と送る
>
> あとは AI が案内します。原稿は VS Code でプレビューできます。セットアップに使ったターミナルは閉じてOKです。
