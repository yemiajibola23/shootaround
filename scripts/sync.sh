#!/usr/bin/env bash
# Update a merged PR's Notion task. Merge the PR on GitHub first.
# Usage: scripts/sync.sh <pr-number>
set -euo pipefail

pr="${1:?usage: scripts/sync.sh <pr-number>}"

python3 "$(dirname "$0")/notion_sync.py" --pr "$pr"
