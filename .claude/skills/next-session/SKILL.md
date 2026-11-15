---
name: next-session
description: Kick off the next Shootaround build session. Reads live state, does the setup chores, then starts the Open protocol. Use when Yemi says "next session", "kick off", "start session", or runs /next-session.
---

# next-session

Kickoff for one Shootaround build session. **Claude does the chores; Yemi does the learning.** Follow `CLAUDE.md` (learning mode, reply format, session protocol). This skill only sets up and starts the Open. It never writes `app/` or `service/` logic.

Optional argument: a task or branch to force (`/next-session TASK-95`). Say "prep only" to do the chores and stop after the brief.

## 1. Gather state (no questions yet)

1. Run `scripts/next-session.sh`. It prints today's date, git state, unpushed branches, lock files, the CLAUDE.md "Next:" line, and the last session's branch, level changes, weak spots, open items and What's next.
2. Read the Notion task for what's next (Tasks DB `26413914-6cd2-4c4f-9e7f-33a7a935173e`, search the `TASK-NN` id or title). Live state = that task + the latest log.
3. Read the concept map for today's task in `docs/learning-method.md` §6 (mode and build level per concept) and §7 (gates and the session table). Use the log's **Level changes** over the map when they differ.
4. If the log's What's next and the Notion task disagree, say so in one line and ask which wins. Otherwise don't ask.

## 2. Decide the session

- Same task, next part → stay on the branch, session number +1.
- New task → new branch `wNN/short-name` from `main`, new log file.
- If the task is too big for one session, stop and propose the split before any chores (CLAUDE.md, Session protocol).

## 3. Chores (do without asking)

- **Previous branch.** Unpushed commits → tell Yemi to push (his step), then open the PR (`Closes`/`Ref TASK-NN`, template in `.github/`). Merged on GitHub → run `scripts/sync.sh <pr>` if the Notion task is not Done yet.
- **Sync main.** `git fetch` (script falls back to HTTPS; SSH fails from the device shell), then `git checkout main && git pull --ff-only`. Never commit to `main`.
- **Branch.** Create `wNN/short-name` only for a new task.
- **Lock files.** Stale `.git/*.lock` after commits: clear them if deletion is allowed, otherwise move aside as `.git/stale-*`. Ignore `objects/maintenance.lock`.
- **Log stub.** New branch → `docs/logs/wNN-short-name.md` with the `# Session N log` header and Branch / task / date line. Same branch → append a new `# Session N log` header. Fill the rest at Close.
- **CLAUDE.md Status.** Fix the status line if it is stale (e.g. "Next:" already done). Chore, not Yemi's work.
- **Chore list.** From the log's Not covered / open, list items that are tooling or cleanup (temp files, stale docs). Do the ones that are chores now. Items that are Yemi's code stay with him: list them, don't touch them.

Do not scaffold test or function stubs here. Those come in the build loop, shown in chat and added to the file together (Yemi's standing preference).

## 4. Open (first message to Yemi)

Obey the reply format: chunks of ≤5 lines, key detail in bold, one question, question last after `---`.

1. **One line:** session N · branch · TASK-NN · date.
2. **Today:** core concept, its mode and build level, professional use. Max two concepts.
3. **Chores done:** one line (branch, sync, PR, anything flagged).
4. **Recap:** 3 bullets max, from the last log.
5. **First retrieval question.** Use the weak spot the log says "opens the next session". Claim + because, scored 0–2 after he answers.

Then **stop and wait.** Questions 2 and 3 of the retrieval come one at a time after his answers (at least one weak spot in total). Teach by mode only after the open, per CLAUDE.md.

## Guardrails

- Never ask more than one question per message, including in the kickoff.
- Cite docs by name ("Scope doc → Card data model"), never "as we discussed".
- Don't print secrets; don't change the Notion schema; sync script writes only Status, Done, Completed on, PR.
- If a tool fails twice, say what failed in one line and continue with what you have.
