#!/bin/sh
# GitHub CLI（gh）を ~/.local/bin に入れ、~/.local/bin を PATH に足す。管理者権限はいらない。
# 入っていれば何もしない。ログイン（gh auth login）は人がブラウザで行うので、ここではしない。
# 使い方: sh install-gh.sh
set -eu

die() { printf 'install-gh: %s\n' "$*" >&2; exit 1; }

bin="$HOME/.local/bin"

# 新しく開くターミナルでも gh と skill-kit が使えるように。
case $(basename "${SHELL:-sh}") in
zsh) rc="$HOME/.zshrc" ;;
bash) rc="$HOME/.bashrc" ;;
*) rc="$HOME/.profile" ;;
esac
if ! grep -qs '\.local/bin' "$rc"; then
	printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >>"$rc"
fi

if command -v gh >/dev/null 2>&1 || [ -x "$bin/gh" ]; then
	echo "gh は入っています"
	exit 0
fi

case $(uname -s)-$(uname -m) in
Darwin-arm64) asset=macOS_arm64.zip ;;
Darwin-x86_64) asset=macOS_amd64.zip ;;
Linux-x86_64) asset=linux_amd64.tar.gz ;;
Linux-aarch64) asset=linux_arm64.tar.gz ;;
*) die "この環境向けの gh がありません: $(uname -s) $(uname -m)" ;;
esac

# API の回数制限を避けるため、latest のリダイレクト先からバージョンを読む。
tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/cli/cli/releases/latest)
v=${tag##*/v}
[ -n "$v" ] || die "gh の最新バージョンが分かりません"

tmp=$(mktemp -d)
curl -fsSL -o "$tmp/gh.$asset" "https://github.com/cli/cli/releases/download/v$v/gh_${v}_$asset"
case $asset in
*.zip) unzip -q "$tmp/gh.$asset" -d "$tmp" ;;
*) tar -xzf "$tmp/gh.$asset" -C "$tmp" ;;
esac
mkdir -p "$bin"
cp "$tmp"/gh_*/bin/gh "$bin/gh"
rm -rf "$tmp"
echo "gh $v を $bin/gh に入れました"
