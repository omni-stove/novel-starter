# 設計メモ

- AI エージェントは opencode（無料なので既定）、Claude Code、Codex から選ぶ。違いは `README.md` のインストールと `install-launcher.sh` の起動コマンドに閉じ込め、セットアップの手順と原稿のリポジトリは共通にする。スキルは skill-kit が `.claude/skills` と `.agents/skills` に配るので、どの AI でも使える
- AI エージェントは専用のターミナルアプリ（Mac は Ghostty、Windows は Windows Terminal）で動かす。VS Code の統合ターミナルは根本的にパフォーマンスに問題があるので使わない。VS Code は原稿のプレビュー専用で、AI エージェントの VS Code 拡張も入れない
- AI エージェントはなるべく早く入れ、コマンドでできることはすべて AI エージェントに任せる。チャット AI が案内するのは AI エージェントを動かすまで（Mac はターミナルを開くだけ、Windows は WSL と Windows Terminal の用意）。Ghostty と VS Code は AI エージェントが `install-apps.sh` で入れる。そのため Mac では、セットアップの間だけ最初から入っている「ターミナル」で AI エージェントを動かす
- 執筆を始めるたびにコマンドを貼らせない。`install-launcher.sh` で、Mac は Ghostty の `initial-command`、Windows は Windows Terminal のフラグメントとデスクトップのショートカットから、作品の置き場所で AI エージェントを始める。Windows Terminal の settings.json は書き換えない
- skill-kit の自動更新は、AI ごとのプラグインやフックではなく起動スクリプト（`novel-start`）で行う。Codex のフックのように信頼の確認が要る仕組みに左右されず、1 か所で済む
