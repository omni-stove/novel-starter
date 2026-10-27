#!/bin/sh
# 原稿のリポジトリを作り、skill-kit の執筆スキルを入れ、GitHub の非公開リポジトリにバックアップする。作品は new-work.sh で足す。
# 1作品だけのリポジトリも、作品を src/<作品> に並べるリポジトリも、ここは同じ。
# 使い方: sh new-repo.sh <フォルダ>
#   clone せずに: curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/new-repo.sh | sh -s -- <フォルダ>
set -eu

die() { printf 'new-repo: %s\n' "$*" >&2; exit 1; }

[ $# -eq 1 ] || die "使い方: sh new-repo.sh <フォルダ>（例: ~/novels）"
dest=$1
[ ! -e "$dest/.git" ] || die "$dest はもうリポジトリです。"

export PATH="$HOME/.local/bin:$PATH"
command -v skill-kit >/dev/null 2>&1 || die "skill-kit がありません。先に sh setup.sh を実行してください。"
gh auth status >/dev/null 2>&1 || die "GitHub にログインしていません。gh auth login でログインしてください。"
name=$(basename -- "$dest")
! gh repo view "$name" >/dev/null 2>&1 || die "GitHub にもう $name というリポジトリがあります。別のフォルダ名にしてください。"

here=$(cd "$(dirname -- "$0")" 2>/dev/null && pwd)
# curl … | sh で実行されたときは、テンプレートを GitHub から一時フォルダに取ってくる。
if [ ! -d "$here/template" ]; then
	here=$(mktemp -d)
	trap 'rm -rf "$here"' EXIT
	curl -fsSL https://codeload.github.com/omni-stove/novel-starter/tar.gz/main | tar -xz -C "$here" --strip-components=1
fi
mkdir -p "$dest"
cp -R "$here/template/repo/." "$dest/"
cd "$dest"
git init -q
skill-kit story sync
git add -A
git commit -q -m "原稿のリポジトリを作る"
gh repo create "$name" --private --source . --remote origin --push >/dev/null
echo "リポジトリを作りました: $(pwd)（GitHub: $(gh repo view --json url -q .url)）"
