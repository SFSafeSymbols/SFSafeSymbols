#!/usr/bin/env node
import { $ } from "zx";
import { promises as fs } from "node:fs";

function mustEnv(name: string): string {
  const v = process.env[name];
  if (!v) throw new Error(`Missing ${name}`);
  return v;
}

async function ensureLatestXcodes(): Promise<void> {
  const hasXcodes = (await $`brew list --formula xcodes`.nothrow().quiet()).exitCode === 0;
  if (!hasXcodes) {
    await $`brew install xcodesorg/made/xcodes`;
    return;
  }

  const outdatedOut = (await $`brew outdated --formula xcodes`.nothrow().quiet()).stdout.trim();
  const isOutdated = outdatedOut.split(/\s+/).includes("xcodes");
  if (isOutdated) {
    await $`brew upgrade xcodes`;
  }
}

async function runtimeInstalled(runtime: string): Promise<boolean> {
  const out = (await $`xcrun simctl list runtimes`.quiet()).stdout;
  return out.includes(runtime);
}

async function installRuntimeIfNeeded(runtime: string): Promise<void> {
  await ensureLatestXcodes();
  const availableRuntimes = (await $`xcodes runtimes`.quiet()).stdout.trim();
  console.log(`== Available runtimes to install ==`);
  console.log(availableRuntimes);
  if (await runtimeInstalled(runtime)) {
    console.log(`== Runtime already installed: ${runtime} ==`);
    return;
  } else {
    if (!availableRuntimes.includes(runtime)) {
      throw new Error(`Runtime "${runtime}" is not available to install`);
    }
    console.log(`== Installing runtime: ${runtime} ==`);
    await $`xcodes runtimes install ${runtime}`;
  }
  console.log(`== Currently available simulators ==`);
  await $`xcrun simctl list devices`;
}

////////////

const XCODE = mustEnv("XCODE");
const PLATFORM = mustEnv("PLATFORM");
const OS = mustEnv("OS");
const DEVICE = mustEnv("DEVICE");
const PROJECT_PATH = mustEnv("PROJECT_PATH");
const SCHEME = mustEnv("SCHEME");

const XCODE_APP = `/Applications/Xcode_${XCODE}.app`;
const DEVELOPER_DIR = `${XCODE_APP}/Contents/Developer`;
const DESTINATION = `platform=${PLATFORM} Simulator,name=${DEVICE},OS=${OS}`;
const RESULT_BUNDLE = `TestResults-${PLATFORM}-${OS}-xcode${XCODE}.xcresult`;

////////////

process.env.DEVELOPER_DIR = DEVELOPER_DIR;

await fs.access(XCODE_APP).catch(() => {
  throw new Error(`Xcode not found at ${XCODE_APP}`);
});
console.log("== Xcode ==");
console.log(`DEVELOPER_DIR=${DEVELOPER_DIR}`);
await $`xcodebuild -version`;

await installRuntimeIfNeeded(`${PLATFORM} ${OS}`);

console.log("== Running tests ==");
console.log(`Destination: ${DESTINATION}`);

await fs.rm(RESULT_BUNDLE, { recursive: true, force: true });

process.env.NSUnbufferedIO = "YES";

await $`set -o pipefail && xcodebuild test -project ${PROJECT_PATH} -scheme ${SCHEME} -destination ${DESTINATION} -resultBundlePath ${RESULT_BUNDLE} 2>&1 | xcbeautify --renderer github-actions`.verbose(true);
