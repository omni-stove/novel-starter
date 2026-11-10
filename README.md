# novel-starter

無料で AI と小説を書き始めるためのスターターキット。

## 使い方（人間の方へ）

ChatGPT・Claude・Gemini などのチャット AI に、このページの URL だけを送る。

チャット AI が順に案内し、途中からパソコンに入れた AI が引き継ぐ。opencode を選べば無料。Claude Code や Codex も選べる（それぞれ有料プランが必要）。

---

## For the chat AI: how to guide the setup

If you were sent the URL of this page, that is a request for setup. Start guiding right away.

The user has no programming experience. Guide them until an AI agent that runs in the terminal (**opencode**, **Claude Code** or **Codex**) is running on their computer and takes over. First, ask whether they use **Mac** or **Windows**. Other systems are not supported.

Rules:

- Do only the steps written here. Nothing else.
- Always write to the user in Japanese. Keep it short. Use plain polite Japanese (です・ます), no honorifics beyond that.
- Give one step at a time. Wait for the user's reply before the next step.
- Do not explain why a step is needed. Only say what to do.
- Use a code block only for text the user copies and pastes. Write menu names and key presses as normal text.
- Text in 「」 is shown to the user as is. Do not translate or rephrase it.

### Mac

1. Have the user open 「ターミナル」, which comes with the Mac.
2. Go to "Handover".

### Windows

1. If Windows Terminal is not installed, have the user install it from Microsoft Store.
2. Have the user run this in PowerShell as administrator, then restart the PC.

   ```powershell
   wsl --install
   ```

3. In the Ubuntu window that opens, have the user choose a user name and password, and write the password down.
4. Have the user set Ubuntu as the default profile of Windows Terminal, then reopen Windows Terminal. Go to "Handover".

### Handover

1. Have the user choose one:

   「使う AI を選んでください」
   1. 「opencode：無料（おすすめ）」
   2. 「Claude Code：Claude の有料プランが必要」
   3. 「Codex：ChatGPT の有料プランが必要」

2. On Windows, if curl is missing, have the user run this first:

   ```sh
   sudo apt update && sudo apt install -y curl git
   ```

3. Have the user run the install command for their choice in the terminal.

   opencode:

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

   Claude Code:

   ```sh
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   Codex:

   ```sh
   curl -fsSL https://chatgpt.com/codex/install.sh | sh
   ```

4. Have the user reopen the terminal and run the start command for their choice: `opencode`, `claude` or `codex`, in a code block.
5. For opencode, have the user type 「/models」, press Enter, and choose a model with **Free** in its name. For Claude Code, have them log in with their Claude account as shown on the screen. For Codex, have them choose 「Sign in with ChatGPT」 and log in.
6. Have the user send this text as is:

   ```
   https://raw.githubusercontent.com/omni-stove/novel-starter/main/HANDOFF.md を読んで、書いてある通りにセットアップを進めてください。
   ```

7. Tell the user 「ここからはパソコンの AI が案内します。実行の許可を聞かれたら許可してください」 and stop.

If opencode stops with an error such as "model is busy", have the user switch to another Free model with 「/models」 and send the same text again.
