#!/bin/sh
# 執筆の道具を入れる。gh でログインしてから実行する（HANDOFF.md から opencode が実行する）。何度実行してもよい。
#   - skill-kit（執筆用スキル集）
#   - VS Code 拡張「小説プレビュー」（novel-kit）
#   - opencode の設定（思考過程を隠す、実行の許可を聞かない）
# 使い方: sh setup.sh
set -eu

say() { printf '\n==> %s\n' "$*"; }
die() { printf 'setup: %s\n' "$*" >&2; exit 1; }

export PATH="$HOME/.local/bin:$PATH"
command -v git >/dev/null 2>&1 || die "git がありません。"
command -v gh >/dev/null 2>&1 || die "gh がありません。先に sh install-gh.sh を実行してください。"
gh auth status >/dev/null 2>&1 || die "GitHub にログインしていません。gh auth login でログインしてください。"

code_cmd=
if command -v code >/dev/null 2>&1; then
	code_cmd=code
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
	code_cmd="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
fi
[ -n "$code_cmd" ] || die "VS Code の code コマンドが見つかりません。VS Code を入れてからもう一度実行してください。"

# --- skill-kit ----------------------------------------------------------------
say "skill-kit"
# 入っていればインストーラが git pull で更新する。
gh api repos/omni-stove/skill-kit/contents/install.sh -q .content | base64 -d | sh

# --- VS Code 拡張 ---------------------------------------------------------------
say "VS Code 拡張"
# 小説プレビューはマーケットプレイスに無いので、GitHub Releases の最新の vsix を入れる。
# Latest は CLI のリリースのこともあるため、vscode-v のタグを探す。
tag=$(gh release list -R omni-stove/novel-kit -L 30 --json tagName -q '.[].tagName' | grep '^vscode-v' | head -n 1)
[ -n "$tag" ] || die "小説プレビューのリリースが見つかりません: https://github.com/omni-stove/novel-kit/releases"
tmp=$(mktemp -d)
gh release download "$tag" -R omni-stove/novel-kit -p novel-preview.vsix -D "$tmp"
"$code_cmd" --install-extension "$tmp/novel-preview.vsix" --force
rm -rf "$tmp"

# --- opencode の表示 ------------------------------------------------------------
say "opencode の表示"
# 思考過程とツールの細部を隠し、結果だけを見せる。実行の許可は聞かない。ほかの設定は残す。
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/opencode/cli.json"
mkdir -p "$(dirname "$cfg")"
python3 - "$cfg" <<'EOF'
import json, os, sys

path = sys.argv[1]
cfg = {}
if os.path.exists(path):
    with open(path) as f:
        cfg = json.load(f)
cfg.setdefault("$schema", "https://opencode.ai/v2/cli.json")
session = cfg.setdefault("session", {})
session.update({"thinking": "hide", "verbosity": "low", "sidebar": "hide", "tps": False, "permissions": "autoaccept"})
mini = cfg.setdefault("mini", {})
mini.update({"thinking": "hide", "tools": "hide"})
cfg["highlights"] = False
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
    f.write("\n")
EOF

say "完了"
