#!/bin/sh
# 執筆に使うアプリを入れる。入っているものは飛ばす。何度実行してもよい。
#   Mac：Ghostty（opencode を動かすターミナル）と VS Code（原稿のプレビュー）
#   Windows（WSL）：VS Code と、その拡張「WSL」。Windows 側に winget で入れる
# どちらも code コマンドを ~/.local/bin に置く（PATH は install-gh.sh が足す）。
# 使い方: sh install-apps.sh
set -eu

say() { printf '\n==> %s\n' "$*"; }
die() { printf 'install-apps: %s\n' "$*" >&2; exit 1; }

bin="$HOME/.local/bin"
mkdir -p "$bin"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# /Applications と ~/Applications のどちらかにあれば、そのパスを返す。
find_app() {
	for d in /Applications "$HOME/Applications"; do
		[ -d "$d/$1" ] && { echo "$d/$1"; return 0; }
	done
	return 1
}

mac() {
	apps=/Applications
	[ -w "$apps" ] || { apps="$HOME/Applications"; mkdir -p "$apps"; }

	say "Ghostty"
	if find_app Ghostty.app >/dev/null; then
		echo "Ghostty は入っています"
	else
		# Ghostty は GitHub Releases に置いていないので、Homebrew の cask から最新の dmg を知る。
		url=$(curl -fsSL https://formulae.brew.sh/api/cask/ghostty.json | grep -o '"url":"[^"]*Ghostty.dmg"' | head -n 1 | cut -d'"' -f4)
		[ -n "$url" ] || die "Ghostty の最新版が分かりません: https://ghostty.org/download"
		curl -fsSL -o "$tmp/Ghostty.dmg" "$url"
		hdiutil attach -quiet -nobrowse -mountpoint "$tmp/mnt" "$tmp/Ghostty.dmg"
		cp -R "$tmp/mnt/Ghostty.app" "$apps/"
		hdiutil detach -quiet "$tmp/mnt"
		echo "Ghostty を $apps に入れました"
	fi

	say "VS Code"
	if find_app "Visual Studio Code.app" >/dev/null; then
		echo "VS Code は入っています"
	else
		curl -fsSL -o "$tmp/vscode.zip" https://update.code.visualstudio.com/latest/darwin-universal/stable
		ditto -x -k "$tmp/vscode.zip" "$apps"
		echo "VS Code を $apps に入れました"
	fi
	command -v code >/dev/null 2>&1 ||
		ln -sf "$(find_app "Visual Studio Code.app")/Contents/Resources/app/bin/code" "$bin/code"
}

windows() {
	# 作業フォルダが WSL 側だと cmd.exe が警告を出すので、Windows 側に移ってから呼ぶ。
	win() { (cd /mnt/c && powershell.exe -NoProfile -NonInteractive -Command "$1") | tr -d '\r'; }

	say "VS Code"
	if command -v code >/dev/null 2>&1; then
		echo "VS Code は入っています"
		vsbin=$(dirname "$(readlink -f "$(command -v code)")")
	else
		vsbin="$(wslpath "$(win '$env:LOCALAPPDATA')")/Programs/Microsoft VS Code/bin"
		if [ ! -f "$vsbin/code" ]; then
			win 'Get-Command winget -ErrorAction Stop | Out-Null' >/dev/null 2>&1 ||
				die "winget がありません。Microsoft Store で「アプリ インストーラー」を更新してから、もう一度実行してください。"
			win 'winget install -e --id Microsoft.VisualStudioCode --scope user --silent --accept-package-agreements --accept-source-agreements'
		fi
		[ -f "$vsbin/code" ] || die "VS Code が入りませんでした: $vsbin"
		ln -sf "$vsbin/code" "$bin/code"
		echo "VS Code を入れました"
	fi

	say "VS Code 拡張「WSL」"
	win "& '$(wslpath -w "$vsbin/code.cmd")' --install-extension ms-vscode-remote.remote-wsl --force"
}

case $(uname -s) in
Darwin) mac ;;
Linux)
	grep -qi microsoft /proc/version || die "Mac か、Windows の WSL で実行してください。"
	windows
	;;
*) die "この環境には対応していません: $(uname -s)" ;;
esac

say "完了"
