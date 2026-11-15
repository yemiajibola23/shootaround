# Session 13 log
- **Branch / task / date:** w04/due-queue / TASK-83 W04-A, Due queue by deck (part 1 of 2) / 2026-11-15
- **Concepts:** `#Predicate` (New, L1): macro compiles the closure to an expression tree, SwiftData translates it to SQL, so the closure must be translatable. Retrieval: `defer`, `@Observable`, pure.
- **Build score:** faded predicate (`dueTodayPredicate`): 0 hints. Deck test: 2 nudges (first fixture used the wrong deck for the not-due card; needed a same-deck counterexample). Implementation: 1 hint (the deck branch dropped `due <= now`), plus the unwrap-outside-closure hint. Refactor to one predicate and one `return`, `let` fixed by himself.
- **Concept score:** pretest 1. Retrieval: `defer` 1, `@Observable` 2, pure 1. Green explanation 2. Close: explain 2, code 1 (missed `deck` first), older concept (`let` on a class) 1. Reason for unwrap-outside-closure: 1 (gave crash safety, not translatable).
- **Level changes:** `#Predicate` stays New / L1 (more than 1 hint on the build). `defer` and pure stay weak (1, 1).
- **Weak spots:** pure means no side effects beyond the return value, not only unchanged inputs; `defer` ties to scope exit, not branches; `let` on a class freezes the reference, not the object; a captured plain value vs an unwrap expression in a predicate.
- **Decisions:** `dueCardsDescriptor(now:deck:)` with `deck: Deck? = nil`; the deck branch ANDs `due <= now` with the deck match; single `let predicate` and one `return`.
- **Not covered / open:** `dueTodayPredicate` was removed (example only); `week03.csv` rows use a `Swift` deck that is not a `Deck` case (check import); review sheet summary, Reveal button, `ReviewView` tests, unused `import SM2Scheduler` in `ContentView`, `splitFields` escaped quotes, frozen `now`. Branch has 2 commits, not pushed.
- **What's next:** W04-A part 2 (Tue Nov 17, Gate 1): wire the deck filter into the UI. Opens with `defer` (still weak).
