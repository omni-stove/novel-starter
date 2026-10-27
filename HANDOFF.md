# opencode へ：セットアップの引き継ぎ

プログラミングの経験がない人の、AI で小説を書く環境のセットアップを引き継いだ。相手はターミナル（Mac は標準の「ターミナル」、Windows は Windows Terminal の WSL Ubuntu）であなたと話している。

コマンドはすべてあなたが実行する。相手にしてもらうのは GitHub へのログインと、画面での操作が要るところだけ。文面は短く、敬語は「です・ます」まで。

## git を用意する

git が無ければ入れる（Mac は `xcode-select --install`、WSL は `apt`）。`user.name` が空なら相手にペンネームなど好きな名前を聞いて設定し、`user.email` は聞かずに `<名前>@users.noreply.github.com` にする。

## スクリプトの実行のしかた

このあと出てくる `<スクリプト>` は clone せずに、GitHub から直接実行する。引数があれば `sh -s --` のあとに付ける。

```sh
curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/<スクリプト> | sh -s -- <引数>
```

## gh とアプリを入れる

`install-gh.sh`、`install-apps.sh` の順に実行する。

## GitHub にログインしてもらう

ログイン済み（`~/.local/bin/gh auth status`）なら次へ。アカウントが無ければ https://github.com/signup で作ってもらう。ログインは対話式なので、相手に新しいターミナルで次を実行してもらい、ブラウザで承認してもらう。

```sh
~/.local/bin/gh auth login --web --hostname github.com --git-protocol https
```

## 道具を入れる

`setup.sh` を実行する。

## 作品のフォルダを作る

作品の仮の名前を聞き（あとで変えられる）、英小文字・数字・ハイフンだけのフォルダ名にする。置き方を選んでもらう。

> 1. **いくつも書く**：作品を並べる棚を作る。あとから作品を足しやすい（おすすめ）
> 2. **この作品だけ**：この作品専用のフォルダを作る

| | `new-repo.sh` の引数 | `new-work.sh` の引数 |
|---|---|---|
| 1 | `~/novels`（もうあれば飛ばす） | `~/novels/src/<フォルダ名>` |
| 2 | `~/novels/<フォルダ名>` | `~/novels/<フォルダ名>` |

## 引き継ぐ

`new-work.sh` が開く VS Code は原稿のプレビュー用（Windows では WSL につないで開く）。相手にこう伝えて終わり。`<作品の置き場所>` は 1 なら `~/novels`、2 なら `~/novels/<フォルダ名>`。

> セットアップ完了です。
> 1. 新しいターミナルを開く（Mac はこれから Ghostty を使います。Windows は Windows Terminal の「＋」）
> 2. 次の一行を貼り付けて Enter
>
>    ```
>    cd <作品の置き場所> && opencode
>    ```
>
> 3. 「書きたい話があります」と送る
>
> あとは AI が案内します。原稿は VS Code でプレビューできます。
