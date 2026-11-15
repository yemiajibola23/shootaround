#!/usr/bin/env bash
# Read-only state brief for kicking off the next Shootaround session.
# Usage: scripts/next-session.sh
# Used by the next-session skill (.claude/skills/next-session/SKILL.md).
set -uo pipefail
cd "$(dirname "$0")/.."

echo "## Today"
date "+%a %b %d %Y"

echo; echo "## Git"
echo "branch: $(git branch --show-current)"
git fetch -q origin main 2>/dev/null \
  || git fetch -q https://github.com/yemiajibola23/shootaround.git main:refs/remotes/origin/main 2>/dev/null \
  || echo "fetch failed (offline, or SSH blocked): behind/ahead may be stale"
echo "main vs origin/main: ahead $(git rev-list --count origin/main..main 2>/dev/null) / behind $(git rev-list --count main..origin/main 2>/dev/null)"
dirty="$(git status --short | head -10)"
echo "uncommitted: ${dirty:-none}"
echo "branches not on origin or ahead of it:"
found=0
while IFS='|' read -r name upstream track; do
  [ "$name" = "main" ] && continue
  if [ -z "$upstream" ] || [[ "$track" == *ahead* ]]; then echo "  $name ${track:-(no upstream)}"; found=1; fi
done < <(git for-each-ref --format='%(refname:short)|%(upstream:short)|%(upstream:track)' refs/heads)
[ "$found" = 0 ] && echo "  none"
echo "lock files: $(find .git -name '*.lock' 2>/dev/null | tr '\n' ' ')"
echo "recent commits on main:"; git log main --oneline -5 | sed 's/^/  /'

echo; echo "## CLAUDE.md status line (check it is not stale)"
grep -o 'Next: [^.]*\.' CLAUDE.md | tail -1

echo; echo "## Latest session log"
latest="$(ls -t docs/logs/*.md 2>/dev/null | head -1)"
if [ -z "$latest" ]; then echo "no logs yet"; exit 0; fi
echo "file: $latest"
block="$(awk '/^# Session /{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' "$latest")"
echo "$block" | grep -E '^# Session|^- \*\*(Branch|Level changes|Weak spots|Not covered|What.s next|Decisions)' 
