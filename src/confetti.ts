import { closeMainWindow, environment, showToast, Toast } from "@raycast/api";
import { execFile } from "node:child_process";
import { chmod } from "node:fs/promises";
import { join } from "node:path";
import { promisify } from "node:util";

const execute = promisify(execFile);

export default async function confetti() {
  try {
    const helper = join(environment.assetsPath, "confetti");
    // ZIP downloads can lose executable bits; only touch our own bundled helper.
    await chmod(helper, 0o755);
    await closeMainWindow();
    await execute(helper, [], { timeout: 10_000, maxBuffer: 64 * 1024 });
  } catch (error) {
    await showToast({
      style: Toast.Style.Failure,
      title: "Could not launch confetti",
      message: error instanceof Error ? error.message : "Try reinstalling the extension.",
    });
  }
}
