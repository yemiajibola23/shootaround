#!/usr/bin/env bash
# Run the SM2Scheduler package tests from the command line.
# Xcode does not offer a dependency package's test target in the app's test plan,
# so this runs them from the package folder. Override the simulator with DEST.
set -euo pipefail
cd "$(dirname "$0")/../app/SM2Scheduler"
DEST="${DEST:-platform=iOS Simulator,name=iPhone 18 Pro}"
xcodebuild test -scheme SM2Scheduler -destination "$DEST"
