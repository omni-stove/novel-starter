// opencode がこのリポジトリを開くたびに、裏で skill-kit を最新にし、執筆スキルを入れ直す。
// 待たずに opencode を使い始められるよう、結果は待たない。失敗しても次の起動でまた試す。
import { spawn } from "node:child_process"
import { homedir } from "node:os"
import { join } from "node:path"

export default {
  id: "skill-kit-update",
  setup: async ({ location }) => {
    const bin = join(homedir(), ".local", "bin")
    const child = spawn(join(bin, "skill-kit"), ["update"], {
      cwd: location.directory,
      env: { ...process.env, PATH: `${bin}:${process.env.PATH ?? ""}` },
      detached: true,
      stdio: "ignore",
    })
    child.on("error", () => {})
    child.unref()
    return {}
  },
}
