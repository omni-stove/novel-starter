#!/bin/sh
# ターミナルを開くだけで、作品の置き場所で opencode が始まるようにする。何度実行してもよい。
#   Mac：Ghostty を開くと、最初のウィンドウで opencode が始まる
#   Windows（WSL）：デスクトップの「小説を書く」から、Windows Terminal で opencode が始まる
# opencode を終えるとふつうのシェルに戻る。
# 使い方: sh install-launcher.sh <作品の置き場所>（例: ~/novels）
#   clone せずに: curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/install-launcher.sh | sh -s -- <作品の置き場所>
set -eu

say() { printf '\n==> %s\n' "$*"; }
die() { printf 'install-launcher: %s\n' "$*" >&2; exit 1; }

[ $# -eq 1 ] || die "使い方: sh install-launcher.sh <作品の置き場所>（例: ~/novels）"
dir=$(cd "$1" 2>/dev/null && pwd) || die "$1 がありません。"

bin="$HOME/.local/bin"
mkdir -p "$bin"

# 作品の置き場所に移って opencode を始め、終わったらシェルに戻るスクリプト。
# ログインかつ対話のシェルで動かし、.zshrc や .bashrc で足した PATH（opencode の場所）を読む。
start="$bin/novel-start"
cat >"$start" <<EOF
#!/bin/sh
cd '$dir' || exit 1
sh=\${SHELL:-/bin/sh}
"\$sh" -lic opencode
exec "\$sh" -l
EOF
chmod +x "$start"

mac() {
	say "Ghostty"
	conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
	mkdir -p "$conf_dir"
	conf="$conf_dir/config"
	[ ! -f "$conf_dir/config.ghostty" ] || conf="$conf_dir/config.ghostty"
	touch "$conf"
	# 前に書いた分を消してから書き直す。ほかの設定は残す。
	sed '/^# >>> novel-starter/,/^# <<< novel-starter/d' "$conf" >"$conf.tmp"
	cat >>"$conf.tmp" <<EOF
# >>> novel-starter
initial-command = $start
working-directory = $dir
# <<< novel-starter
EOF
	mv "$conf.tmp" "$conf"
	echo "Ghostty を開くと $dir で opencode が始まります（設定: $conf）"
}

windows() {
	win() { (cd /mnt/c && powershell.exe -NoProfile -NonInteractive -Command "$1") | tr -d '\r'; }
	distro=${WSL_DISTRO_NAME:-Ubuntu}
	local_app=$(wslpath "$(win '$env:LOCALAPPDATA')")

	say "Windows Terminal のプロファイル「小説を書く」"
	# settings.json は触らず、フラグメントでプロファイルを足す。
	frag="$local_app/Microsoft/Windows Terminal/Fragments/novel-starter"
	mkdir -p "$frag"
	cat >"$frag/novel.json" <<EOF
{
  "profiles": [
    {
      "guid": "{6f1c3b2e-8a4d-4c5e-9b7a-2d1e0f3c4b5a}",
      "name": "小説を書く",
      "commandline": "wsl.exe -d $distro -- $start"
    }
  ]
}
EOF

	say "デスクトップのショートカット「小説を書く」"
	# 日本語の名前を確実に渡すため、BOM 付き UTF-8 の ps1 にして実行する。
	tmp=$(mktemp -d "$local_app/Temp/novel-starter.XXXXXX")
	trap 'rm -rf "$tmp"' EXIT
	printf '\357\273\277' >"$tmp/shortcut.ps1"
	cat >>"$tmp/shortcut.ps1" <<'EOF'
$desktop = [Environment]::GetFolderPath('Desktop')
$wt = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\wt.exe'
if (-not (Test-Path $wt)) { throw 'Windows Terminal (wt.exe) が見つかりません' }
$lnk = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $desktop '小説を書く.lnk'))
$lnk.TargetPath = $wt
$lnk.Arguments = '-p "小説を書く"'
$lnk.Save()
EOF
	(cd /mnt/c && powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$(wslpath -w "$tmp/shortcut.ps1")") | tr -d '\r'
	echo "デスクトップの「小説を書く」から $dir で opencode が始まります"
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
