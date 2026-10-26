#!/bin/sh
# 原稿のリポジトリを作り、skill-kit の執筆スキルを入れる。作品は new-work.sh で足す。
# 1作品だけのリポジトリも、作品を src/<作品> に並べるリポジトリも、ここは同じ。
# 使い方: sh new-repo.sh <フォルダ>
set -eu

die() { printf 'new-repo: %s\n' "$*" >&2; exit 1; }

[ $# -eq 1 ] || die "使い方: sh new-repo.sh <フォルダ>（例: ~/novels）"
dest=$1
[ ! -e "$dest/.git" ] || die "$dest はもうリポジトリです。"

export PATH="$HOME/.local/bin:$PATH"
command -v skill-kit >/dev/null 2>&1 || die "skill-kit がありません。先に sh setup.sh を実行してください。"

here=$(cd "$(dirname -- "$0")" && pwd)
mkdir -p "$dest"
cp -R "$here/template/repo/." "$dest/"
cd "$dest"
git init -q
skill-kit story sync
git add -A
git commit -q -m "原稿のリポジトリを作る"
echo "リポジトリを作りました: $(pwd)"
