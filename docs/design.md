# 設計メモ

- opencode は専用のターミナルアプリ（Mac は Ghostty、Windows は Windows Terminal）で動かす。VS Code の統合ターミナルは根本的にパフォーマンスに問題があるので使わない。VS Code は原稿のプレビュー専用で、opencode の VS Code 拡張も入れない
- opencode はなるべく早く入れ、コマンドでできることはすべて opencode に任せる。チャット AI が案内するのは opencode を動かすまで（Mac はターミナルを開くだけ、Windows は WSL と Windows Terminal の用意）。Ghostty と VS Code は opencode が `install-apps.sh` で入れる。そのため Mac では、セットアップの間だけ最初から入っている「ターミナル」で opencode を動かす
