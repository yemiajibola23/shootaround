#!/usr/bin/env bash
# Merge a PR, then update its Notion task.
# Usage: scripts/merge_and_sync.sh <pr-number>
set -euo pipefail

pr="${1:?usage: scripts/merge_and_sync.sh <pr-number>}"

gh pr merge "$pr" --merge --delete-branch
python3 "$(dirname "$0")/notion_sync.py" --pr "$pr"
