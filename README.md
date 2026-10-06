# Shootaround

A single-user iPhone app for daily interview drills, scheduled with spaced repetition (SM-2) and backed by a local Python AI service.

Status: v1 in progress (target Sun Dec 13, 2026).

## Layout

| Path | What |
|---|---|
| `app/` | Xcode project (SwiftUI, SwiftData) |
| `service/` | FastAPI service (Week 5+) |
| `data/decks/` | CSV card decks |
| `docs/logs/` | Session logs |
| `scripts/notion_sync.py` | Links merged PRs to Notion tasks |

## Workflow

- Branch: `wNN/short-name`
- PR title: `TASK-NN: Title`
- PR description: `Closes TASK-NN` (marks the task Done) or `Ref TASK-NN` (link only)
- On merge, the `notion-sync` GitHub Action updates the Notion task.
