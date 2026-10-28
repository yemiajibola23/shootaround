> Repo copy of the claude.ai Project doc `claude/learning-method.md` (v2, updated Oct 27, 2026). If the two differ, update both.

# Shootaround learning method (v2 · updated Oct 27, 2026)

Session chats read this doc to set levels, pick review questions and format replies. It replaces the single global L1/L2/L3 level in the project instructions.

## 1. How to format every reply (highest priority)

Yemi finds long blocks of text hard to read and ends up skimming to the last lines.

- **Short chunks.** At most ~5 lines of prose between breaks. One idea per chunk.
- **One question per message.** Ask, then wait. Never batch questions, including in the open and close reviews.
- **Key detail first, in bold.** The question or action goes last, on its own line.
- **Code blocks of 10 lines or fewer.** Split longer code into pieces.
- **No big tables in chat.** Tables live in docs like this one.
- Use a horizontal rule (`---`) before each new question.

## 2. Skills assessment (Oct 18, 2026)

Twelve questions, one at a time. 8/20 on the ten scored questions (40%).

| # | Area | Score | What it showed |
|---|---|---|---|
| 1 | Swift value types | 2/2 | Solid, with a clear "because" |
| 2 | Failable init type | 1/2 | Missed that the result is `Deck?` |
| 3 | `try` / `try?` / `try!` | 1/2 | Mixes up *throws* and *returns nil* (root of the session 2 `try?` bug) |
| 4 | `@State` vs `@Binding` | 1/2 | Ownership idea right; called views classes; Binding is read-write |
| 5 | SwiftData / `@Query` | — | Never used `@Query`; has seen `ObservableObject` |
| 6 | `@MainActor` | 2/2 | Solid |
| 7 | Python mutable default arg | 0/2 | Didn't know defaults are shared |
| 8 | List comp vs generator | 0/2 | Didn't know |
| 9 | Built an HTTP API | — | Has *called* APIs, never built a server |
| 10 | RAG | 0/2 | Didn't know |
| 11 | LLM temperature | 0/2 | Didn't know |
| 12 | SQL `GROUP BY` | 1/2 | Right pieces, `AVG` in the wrong clause |

**Findings**
1. **Swift is rusty but there.** You know how things behave; the gaps are exact types and terms.
2. **Python is weaker than the scope doc assumes.** It says "AI and data work stays in Python, where you're strongest". Intermediate Python idioms need teaching.
3. **The AI course didn't stick.** RAG and temperature were both blanks, so all AI weeks are L1/New.
4. **SQL basics are there.** The clause order needs a refresh.
5. **Cross-cutting:** answers that include a "because" score higher (Q1). Keep requiring it.

## 3. Diagnosis of the old method (sessions 1–2)

- The L1 step comments did the reasoning, so good code hid the concept gaps.
- Coding was practiced and explaining was tested, so explaining never got rehearsed.
- Too many concepts per session (seven in session 2).
- One global level treated strong and brand-new topics the same.
- Session 1's tooling detours took attention from learning.

## 4. Techniques

- **Pretest:** one prediction question before teaching a New concept.
- **Self-explanation:** after each green test, one sentence of "this works because…" using the concept's term. Scored 0–2.
- **Faded scaffolding:** the next similar piece in a session goes up one build level if the last took ≤1 hint.
- **Claim + because:** every review answer must give a reason.
- **Name it:** every idea gets a name you're graded on, plus one "name the technique" card per session.
- **Spaced retrieval + interleaving:** reviews mix weak and stale concepts.
- **One core concept per session** (max two).
- **NBA examples** in worked examples.

(Matching teaching to a "learning style" isn't supported by evidence. These techniques are.)

## 5. Level system: two axes, per concept

**Build level:** L1 = signature + detailed steps · L2 = signature + high-level comments · L3 = signature only.

**Concept mode:**
- **New:** pretest → 2-line mental model + diagram → worked example → faded example.
- **Refresh:** you explain first, Claude corrects.
- **Stretch:** skip teaching, go to interview-depth questions.

**Movement (per concept):**
- Build: ≤1 hint and no structural fix → next piece up one level. Two steps rewritten → down one.
- Concept: 2/2 in two separate sessions → cards only. A 0 → opens the next session.
- Log Build and Concept scores separately.

## 6. Concept map

*Basis:* **assessed** = Oct 18 assessment or sessions 1–2. **est.** = estimate, checked by the pretest the first time it comes up.

### Week 1 · W01-C
| Concept | Build | Mode | Basis |
|---|---|---|---|
| Enums + failable init (`Deck?`) | L2 | Refresh | assessed (Q2) |
| Optionals, `guard let` | L2 | Refresh | assessed |
| Error handling: `throws` vs optional, `try` variants | L2 | Refresh | assessed (Q3) |
| Value vs reference types | L2 | Refresh | assessed (Q1 2/2; weak in sessions 1–2) |
| Swift Testing + TDD vocabulary | L2 | Refresh | assessed |
| Quoted-field parsing (state machine) | L1 | New | est. |

### Week 2 · SM-2 scheduler
| Concept | Build | Mode | Basis |
|---|---|---|---|
| SM-2 algorithm | L2 | New | est. |
| Pure functions + value-type design | L2 | New | est. |
| Swift packages + access control | L1 | New | est. |
| Boundary testing | L2 | Refresh | assessed |
| Parameterized tests `@Test(arguments:)` | L1 | New | est. |

### Weeks 3–4 · Review screen, persistence, due queue
| Concept | Build | Mode | Basis |
|---|---|---|---|
| SwiftUI `@State` / `@Binding` | L1 | Refresh | assessed (Q4) |
| `@Observable` vs `ObservableObject` | L1 | New | assessed (Q5) |
| SwiftData: `@Query`, `modelContext`, `ModelContainer` | L1 | New | assessed (Q5) |
| File import (`fileImporter`) | L1 | New | est. |
| `#Predicate` queries | L1 | New | est. |
| Date/Calendar math (streaks) | L2 | New | est. |

### Week 5 · FastAPI + networking
| Concept | Build | Mode | Basis |
|---|---|---|---|
| **Python primer:** mutability, generators, type hints | L1 | New | assessed (Q7–8) |
| FastAPI routes + Pydantic models | L1 | New | assessed (Q9) |
| REST design from the server side | L1 | New | assessed (Q9) |
| Swift `async/await` + `URLSession` + `Codable` | L2 | Refresh | assessed (Q6) |
| Swift 6 concurrency (actors, `Sendable`) | L1 | New | est. (`@MainActor` basics solid) |

### Weeks 6–8 · AI service
| Concept | Build | Mode | Basis |
|---|---|---|---|
| LLM basics: tokens, temperature, system prompts | L1 | New | assessed (Q11) |
| Structured output (JSON → Pydantic) | L1 | New | assessed |
| Provider interface (Protocol/ABC) | L1 | New | est. |
| RAG pipeline: chunk → embed → store → retrieve → generate (moved to January) | L1 | New | assessed (Q10) |
| Embeddings + vector similarity (moved to January) | L1 | New | assessed |
| ChromaDB + citations (moved to January) | L1 | New | est. |
| LLM-as-judge grading | L1 | New | est. |
| Evals + agreement metrics | L1 | New | est. |

### Weeks 9–10 · NBA data, CI, write-up
| Concept | Build | Mode | Basis |
|---|---|---|---|
| `nba_api` ingest (rate limits, caching) | L2 | New | est. (Python primer first) |
| SQLite schema design | L2 | Refresh | est. |
| SQL `GROUP BY`, aggregates, clause order | L1 | Refresh | assessed (Q12) |
| SQL window functions | L1 | New | est. |
| pandas (`groupby`, `merge`, per-36) | L1 | New | est. (Python gaps) |
| Advanced stats (TS%, eFG%, usage) | L2 | Refresh | est. |
| CI (GitHub Actions) | L2 | New | est. Actions was blocked by billing; fix before Week 10 |
| Architecture write-up | — | Stretch | est. |

## 7. Plan adjustments

1. **Python primer before Week 5.** One short session (Week 4 or start of Week 5): references and mutability, generators, type hints, virtual envs. It links to Q1: shared reference vs copy.
2. **LLM basics before Week 6.** Fold temperature, tokens and system prompts into the Week 6 open as the pretest, not a separate session.
3. **Seed the deck now.** Add cards for the twelve assessment answers so Shootaround drills them from Week 3.
4. **Schedule risk.** Weeks 5–8 are now almost all L1/New. Expect some tasks to split in two. The scope doc's carry-over-once rule covers one miss; flag early if Week 6 or 7 runs long.
5. **Decided Oct 18:** the streak (W04-B) and the NBA data deck (W09-A/B, plus the W10 stats drills) move to January. v1 lands about Dec 22. (Superseded Oct 27: see item 6.)
6. **Decided Oct 27:** v1 ships Sun Jan 3, 2027 (was Dec 13). Pace was about 0.6 plan-weeks per week, so the plan is now 3 sessions a week (Tue/Thu/Sun, 2.5 h). RAG (W7) moves to January with the streak and the NBA data deck. Gate 1 moves to Nov 17 and Gate 2 to Dec 20; Go stays Jan 4. See `claude/schedule-reset-oct-27.md`.

### Revised session schedule (Tue/Thu/Sun, as of Oct 27, 2026)
Two-part tasks take two sessions. Thanksgiving, Dec 24 and Dec 31 are off. About 24 sessions fit through Jan 3, with no slack.

| Week of | Tue | Thu | Sun |
|---|---|---|---|
| Nov 2 | W02-C package SM-2 | W03-A part 1 | W03-A part 2 |
| Nov 9 | W03-B part 1 | W03-B part 2 | W04-A part 1 |
| Nov 16 | W04-A part 2 (Gate 1, Nov 17) | W05-0 Python primer | W05-A part 1 |
| Nov 23 | W05-A part 2 | off (Thanksgiving) | W05-B part 1 |
| Nov 30 | W05-B part 2 | W06-A part 1 | W06-A part 2 |
| Dec 7 | W06-B part 1 | W06-B part 2 | W08-A part 1 |
| Dec 14 | W08-A part 2 | W08-B part 1 | W08-B part 2 (Gate 2, Dec 20) |
| Dec 21 | W10-A CI | off (Dec 24) | W10-B part 1 |
| Dec 28 | W10-B part 2 | off (Dec 31) | Demo video + TestFlight (ship, Jan 3) |

January 2027, after v1: W04-B streak (Jan 5), W09-A (Jan 7), W07-A RAG (Jan 10), W09-B (Jan 12), W07-B RAG (Jan 14). Go is Jan 4; mock interviews Jan 5.

## 8. Session protocol

> **Shootaround session protocol (v2)**
>
> Levels, modes and reply format come from this doc.
>
> **Ground rules**
> - Short chunks (≤5 lines), key detail first in bold, question last.
> - One question at a time. Wait for my answer.
> - One branch = one conversation = one Notion task. Max two core concepts.
> - Chores happen outside the build loop.
> - Never move on until I confirm. "Just tell me" means answer directly.
>
> **1. Open (~10 min)**
> 1. Recap: 3 bullets max.
> 2. Retrieval: 3 questions, one at a time, at least one weak spot. I answer as claim + because.
> 3. Today: branch, task, core concept, its mode and build level, professional use.
> 4. Teach by mode. New: pretest → mental model + diagram → worked example → faded example. Refresh: I explain, you correct. Stretch: interview-depth question.
> 5. The concept's one-sentence definition and the term I'm graded on.
>
> **2. Build loop (TDD), per piece**
> 1. Red: test signature at the build level. I predict why it fails, then run it. → confirm
> 2. Implement: function signature at the build level. I write it.
> 3. Review with leading questions, aimed at *why*.
> 4. Green → I explain in one sentence why it works, using the term. → confirm
> 5. Fade the next similar piece up a level if I needed ≤1 hint.
> 6. Optional refactor → review → green. → confirm
>
> **3. Close (~10 min)**
> 1. 3 questions, one at a time: explain-out-loud, code, one older concept.
> 2. 3–5 CSV cards, including one "name the technique" card.
> 3. Log: branch / task / date; concepts; Build score; Concept score; level changes; weak spots; next.
> 4. Preview (3 lines).
