import { execFileSync } from "node:child_process";
import { createHash } from "node:crypto";
import { cpSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const manifest = JSON.parse(readFileSync("package.json", "utf8"));
if (!existsSync("dist/confetti.js")) throw new Error("Run npm run build first.");
const release = resolve("release");
const folder = resolve(release, "tinycast-confetti");
mkdirSync(release, { recursive: true });
rmSync(folder, { recursive: true, force: true });
mkdirSync(folder);
for (const name of ["package.json", "confetti.js", "assets"]) {
  cpSync(resolve("dist", name), resolve(folder, name), { recursive: true });
}
for (const name of ["README.md", "LICENSE"]) cpSync(name, resolve(folder, name));
const archive = `tinycast-confetti-v${manifest.version}.zip`;
rmSync(resolve(release, archive), { force: true });
execFileSync("/usr/bin/ditto", ["-c", "-k", "--keepParent", "--norsrc", folder, resolve(release, archive)]);
const hash = createHash("sha256").update(readFileSync(resolve(release, archive))).digest("hex");
writeFileSync(resolve(release, "SHA256SUMS"), `${hash}  ${archive}\n`);
console.log(`Packaged release/${archive}`);
