#!/bin/sh
# new-repo.sh で作ったリポジトリに作品を足し、リポジトリを VS Code で開く。
#   1作品だけのリポジトリ:   sh new-work.sh ~/novels/lighthouse-letters        （リポジトリそのもの）
#   作品を並べるリポジトリ: sh new-work.sh ~/novels/src/lighthouse-letters    （その中のフォルダ）
# 使い方: sh new-work.sh <作品のフォルダ>
set -eu

die() { printf 'new-work: %s\n' "$*" >&2; exit 1; }

[ $# -eq 1 ] || die "使い方: sh new-work.sh <作品のフォルダ>"
dest=$1
[ ! -e "$dest/README.md" ] && [ ! -e "$dest/story" ] || die "$dest にはもう作品があります。"

here=$(cd "$(dirname -- "$0")" && pwd)
mkdir -p "$dest"
cd "$dest"
root=$(git rev-parse --show-toplevel 2>/dev/null) || die "$dest は new-repo.sh で作ったリポジトリの中にありません。"
[ -d "$root/.agents/skills" ] || die "$root に skill-kit が入っていません。new-repo.sh で作ったリポジトリを使ってください。"
cp -R "$here/template/work/." .
git add -A .
git commit -q -m "作品 $(basename "$(pwd)") を足す"
echo "作品を足しました: $(pwd)"

if command -v code >/dev/null 2>&1; then
	code "$root"
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
	"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$root"
else
	echo "VS Code で $root を開いてください。"
fi
