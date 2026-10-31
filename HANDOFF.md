# For opencode: setup handover

You are taking over a setup. The user has no programming experience and wants an environment for writing novels with AI. They talk to you in a terminal: on Mac, the built-in 「ターミナル」; on Windows, WSL Ubuntu in Windows Terminal.

Rules:

- Do only the steps written here. Nothing else.
- You run every command yourself. The user only logs in to GitHub and does things that need the screen.
- Always write to the user in Japanese. Keep it short. Use plain polite Japanese (です・ます), no honorifics beyond that.
- Do not explain why a step is needed. Only say what to do.
- Use a code block only for text the user copies and pastes. Do not show the commands you run yourself, or write them as normal text.
- Text in 「」 or in quote blocks (>) is shown to the user as is. Do not translate or rephrase it.

## 1. Prepare git

If git is missing, install it (Mac: `xcode-select --install`, WSL: `apt`). If `user.name` is empty, ask the user for any name they like, such as a pen name, and set it. Do not ask for `user.email`; set it to `<name>@users.noreply.github.com`.

## How to run scripts

Do not clone. Run each `<script>` below directly from GitHub. Put arguments after `sh -s --`.

```sh
curl -fsSL https://raw.githubusercontent.com/omni-stove/novel-starter/main/<script> | sh -s -- <arguments>
```

## 2. Install gh and apps

Run `install-gh.sh`, then `install-apps.sh`.

## 3. Have the user log in to GitHub

If already logged in (`~/.local/bin/gh auth status`), go to the next step. If the user has no account, have them create one at https://github.com/signup. Have the user open a new terminal, run this, and approve in the browser:

```sh
~/.local/bin/gh auth login --web --hostname github.com --git-protocol https
```

## 4. Install the tools

Run `setup.sh`.

## 5. Create the folder for the work

Ask the user for a working title of their novel (they can change it later). Turn it into a folder name using only lowercase letters, digits and hyphens. Then have them choose one:

> 1. **いくつも書く**：作品を並べる棚を作る。あとから作品を足しやすい（おすすめ）
> 2. **この作品だけ**：この作品専用のフォルダを作る

Run `new-repo.sh`, then `new-work.sh`, with these arguments:

| Choice | `new-repo.sh` | `new-work.sh` |
|---|---|---|
| 1 | `~/novels` (skip if it already exists) | `~/novels/src/<folder>` |
| 2 | `~/novels/<folder>` | `~/novels/<folder>` |

## 6. Finish

Tell the user this and stop. Replace `<作品の置き場所>` with `~/novels` for choice 1, or `~/novels/<folder>` for choice 2.

> セットアップ完了です。
> 1. 新しいターミナルを開く（Mac は Ghostty、Windows は Windows Terminal の「＋」）
> 2. 次の一行を貼り付けて Enter
>
>    ```
>    cd <作品の置き場所> && opencode
>    ```
>
> 3. 「書きたい話があります」と送る
>
> あとは AI が案内します。原稿は VS Code でプレビューできます。
