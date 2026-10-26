# Session 5 log

- **Branch / task / date:** w02/sm2-due-dates / TASK-98 W02-B, SM-2 due dates + edge cases / 2026-10-25
- **Scope change:** TASK-98 split (four concepts > two). Packaging moved to W02-C · Package the SM-2 scheduler (`w02/sm2-package`). Big-O dropped as a core concept.
- **Concepts covered:** calendar arithmetic (New, L2), with dependency injection as the support term; boundary testing (Refresh, L2)
- **Built (3 commits):** `secondPassSetsSixDayInterval` (14a2210); `dueDate(reviewDate:intervalDays:calendar:)` + `dueDateCrossesFallBack` (469528b); `gradeThreeStillCountsAsPass` + `calculateEase` extracted from `sm2Update` (eb1dae2). 8 SM-2 tests, all green, still in `SM2Tests.swift`. Mutation checks done on pieces 1 and 3.
- **Concept score:** open 0+1+1 = 2/6; green explanations 1+1+1 = 3/6; close 1+2+2 = 5/6; total 10/18 (56%). Also: design choice (separate `dueDate`) 2/2; faded `isGameDay` 0 hints.
- **Build score:** piece 1 (L2): 2 hints (expected 6 not 15; input interval 1). Piece 2 (L2): 3 hints (hour 0 not 12; calendar parameter; hardcoded `2`) + typo fixed directly (`American/Chicago`). Piece 3 (L2): 4 hints (`round` to whole number; its purpose; expected ease 2.36; compared to 0.14) + structural fix to production code.
- **Level changes:** next similar SM-2 test piece drops to L1 (two steps rewritten on piece 3). Floating-point tolerance scored 0 at open, so it opens next session.
- **Weak spots:** floating-point tolerance (0 at open; then compared to the nudge, not the result); test oracle (expected value computed by calling the code under test); changed production code to make a test easier (`round`); pure function definition missed determinism; green self-explanations name the term but skip the because (all 1/2); dependency injection reason (hidden input) missing from the close answer; "calendar arithmetic" used backwards once.
- **Wins:** failable init type `Deck?` answered 2/2 (first time after two misses); test oracle 2/2 at close; chose single responsibility for `dueDate` unprompted.
- **Decisions:** due date is its own pure function with an injected `Calendar`; `sm2Update` stays date-free. Commit after each red-green-refactor cycle. Step comments do not have to stay in the code.
- **Not covered / open:** grade-5 ease test (L1, use tolerance, expect 2.6); second `dueDate` test with a different interval (would have caught the hardcoded `2`); the `!` in `dueDate` is undocumented; `newRepetitons` typo, `gap` name, `var newInterval` could be `let`. Branch not pushed (Claude's git push/pull fails on SSH host key; Yemi pushes).
- **Cards:** 5 rows appended to `data/decks/week02.csv` (calendar arithmetic x2, dependency injection, floating-point tolerance, test oracle).
- **What's next:** finish W02-B (2 tests, then PR), then W02-C · Package the SM-2 scheduler.
