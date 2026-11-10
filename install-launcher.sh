#!/bin/sh
# ターミナルを開くだけで、作品の置き場所で AI エージェントが始まるようにする。何度実行してもよい（使う AI の切り替えにも使う）。
#   Mac：Ghostty を開くと、最初のウィンドウで AI エージェントが始まる
#   Windows（WSL）：デスクトップの「小説を書く」から、Windows Terminal で AI エージェントが始まる
# AI エージェントを終えるとふつうのシェルに戻る。
# 使い方: sh install-launcher.sh <作品の置き場所> [opencode|claude|codex]（例: ~/novels claude。省略すると opencode）
#   clone せずに: curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/install-launcher.sh | sh -s -- <作品の置き場所> [opencode|claude|codex]
set -eu

say() { printf '\n==> %s\n' "$*"; }
die() { printf 'install-launcher: %s\n' "$*" >&2; exit 1; }

usage="使い方: sh install-launcher.sh <作品の置き場所> [opencode|claude|codex]（例: ~/novels claude）"
[ $# -eq 1 ] || [ $# -eq 2 ] || die "$usage"
dir=$(cd "$1" 2>/dev/null && pwd) || die "$1 がありません。"
agent=${2:-opencode}
# 実行の許可は各 AI の自動レビューに任せ、利用者には聞かない。全部素通しにするフラグは使わない。
case $agent in
opencode) agent_cmd=opencode ;;
claude) agent_cmd="claude --permission-mode auto" ;;
codex) agent_cmd="codex --approve-for-me" ;;
*) die "$usage" ;;
esac

bin="$HOME/.local/bin"
mkdir -p "$bin"

# 作品の置き場所に移って AI エージェントを始め、終わったらシェルに戻るスクリプト。
# どの AI でも同じように、裏で skill-kit を最新にし、執筆スキルを入れ直す。待たずに始められるよう結果は待たない。失敗しても次の起動でまた試す。
# ログインかつ対話のシェルで動かし、.zshrc や .bashrc で足した PATH（AI エージェントの場所）を読む。
start="$bin/novel-start"
cat >"$start" <<EOF
#!/bin/sh
cd '$dir' || exit 1
'$bin/skill-kit' update >/dev/null 2>&1 &
sh=\${SHELL:-/bin/sh}
"\$sh" -lic '$agent_cmd'
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
	echo "Ghostty を開くと $dir で $agent が始まります（設定: ${conf}）"
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
	echo "デスクトップの「小説を書く」から $dir で $agent が始まります"
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
