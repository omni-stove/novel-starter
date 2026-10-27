#!/bin/sh
# new-repo.sh で作ったリポジトリに作品を足し、リポジトリを VS Code で開く。
#   1作品だけのリポジトリ:   sh new-work.sh ~/novels/lighthouse-letters        （リポジトリそのもの）
#   作品を並べるリポジトリ: sh new-work.sh ~/novels/src/lighthouse-letters    （その中のフォルダ）
# 使い方: sh new-work.sh <作品のフォルダ>
#   clone せずに: curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/new-work.sh | sh -s -- <作品のフォルダ>
set -eu

die() { printf 'new-work: %s\n' "$*" >&2; exit 1; }

[ $# -eq 1 ] || die "使い方: sh new-work.sh <作品のフォルダ>"
dest=$1
[ ! -e "$dest/README.md" ] && [ ! -e "$dest/story" ] || die "$dest にはもう作品があります。"

export PATH="$HOME/.local/bin:$PATH"
here=$(cd "$(dirname -- "$0")" 2>/dev/null && pwd)
# curl … | sh で実行されたときは、テンプレートを GitHub から一時フォルダに取ってくる。
if [ ! -d "$here/template" ]; then
	here=$(mktemp -d)
	trap 'rm -rf "$here"' EXIT
	curl -fsSL https://codeload.github.com/omni-stove/novel-starter/tar.gz/main | tar -xz -C "$here" --strip-components=1
fi
mkdir -p "$dest"
cd "$dest"
root=$(git rev-parse --show-toplevel 2>/dev/null) || die "$dest は new-repo.sh で作ったリポジトリの中にありません。"
[ -d "$root/.agents/skills" ] || die "$root に skill-kit が入っていません。new-repo.sh で作ったリポジトリを使ってください。"
cp -R "$here/template/work/." .
git add -A .
git commit -q -m "作品 $(basename "$(pwd)") を足す"
! git -C "$root" remote get-url origin >/dev/null 2>&1 || git push -q
echo "作品を足しました: $(pwd)"

if command -v code >/dev/null 2>&1; then
	code "$root"
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
	"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$root"
else
	echo "VS Code で $root を開いてください。"
fi
