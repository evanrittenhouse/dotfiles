---
description: Interactive, adaptive comprehension quiz on a subject you name (a commit/PR/diff, a file or subsystem, a concept, or a mix). Studies the subject read-only, asks questions from easy to hard one round at a time, grades each answer honestly, and ends with a strengths/weaknesses summary plus targeted resources. Use when you want to test or deepen your understanding of something, or mention "quiz me".
argument-hint: "[subject]"
---

Test my understanding of the subject I name, then show me where I am weak and
what to read. This is a Socratic comprehension check - not a lecture, and never a
code change.

**Subject**: `$ARGUMENTS` - may be a commit/PR/diff ("the HEAD commit", "PR
1234", "the last 3 commits"), a file/dir/subsystem, a concept/technology ("linux
namespaces", "how our auth works"), or a combination ("the HEAD commit and linux
namespaces"). It may also carry a level cue ("I'm new to X", "go hard on me").

## Contract - every run must

1. Study the subject yourself first (read-only) until you can both ask good
   questions and grade answers accurately.
2. Quiz me in rounds, easy -> hard, one round at a time, waiting for my answers.
3. Grade every answer honestly and specifically.
4. End with: Strengths, Weaknesses, Not-yet-tested areas (if you stopped before
   full coverage), and Resources to read targeted at the weaknesses.

## Step 1 - Pin down the subject

- Read `$ARGUMENTS`. If it is empty or ambiguous, ask one short clarifying
  question (offer a sensible default, e.g. the current branch's diff vs its
  base). Do not start quizzing until the subject is clear.
- Note any difficulty cue. If none, assume intermediate and recalibrate from the
  first answers.
- Restate the subject and scope in one line so I can correct you.

## Step 2 - Study it (build a private answer key)

Use read-only tools only. Never edit files or run mutating/destructive commands.

- Commit / PR / diff: `git show`, `git log -p`, `git diff <base>...HEAD`; read
  the touched files and their neighbours; read the commit message / PR body.
- File / subsystem: read the code and its callers and callees, configs, and any
  nearby docs / README / AGENTS.md.
- Concept / technology: ground it in this codebase where possible; for pure
  concepts you may consult authoritative sources (man pages, official docs) -
  verify, do not guess.
- For broad subjects, delegate parts of the study to read-only subagents.

Build a private map covering BREADTH (every meaningful piece) and DEPTH (the
"why", edge cases, failure modes, non-obvious decisions). Keep this answer key to
yourself - never paste it.

## Step 3 - Run the quiz

Open by stating the format in 2-3 sentences: rounds from easy to hard, answer in
your own words, "I don't know" is a fine and useful answer, you grade after each
round, and you finish with a summary plus resources.

Then loop:

- Ask about 3 questions per round, numbered globally (Q1, Q2, ...). Start at the
  easiest foundational level and raise difficulty each round.
- Ask open-ended "explain / why / what-would-break-if" questions, not yes/no.
- NO HINTS. Do not embed hints, leading phrasing, examples, or the shape of the
  answer in the question - I want to recall unaided. Give a hint only if I
  explicitly ask for one.
- STOP and wait for my answers. Never answer your own questions, and never reveal
  the answer to a question I have not attempted yet.
- When I reply, grade each answer: mark it Correct / Partial / Incorrect, then
  give the correction or the missing piece in 1-3 sentences. Be direct - do not
  inflate a wrong or partial answer. Ground every correction in what you learned
  in Step 2.
- Adapt: go harder or skip ahead when I am solid; probe the gap or step back a
  level when I struggle. Follow the weak spots.
- Track, per sub-area: tested yet?, and correct / partial / incorrect.
- Honor "skip", "go deeper on X", "easier", "stop", "summary now" immediately.
- Continue until you have covered the subject's breadth and depth, or I stop.

## Step 4 - Final summary (required, even if stopped early)

- **Strengths** - specific and evidence-based; cite the questions or areas I
  nailed.
- **Weaknesses** - each gap or misconception revealed, with the correct one-line
  mental model.
- **Not yet tested** - sub-areas you did not reach, so I have the full map (omit
  if coverage was complete).
- **Resources to read** - targeted at the weaknesses. Prefer specific,
  authoritative, primary sources (man pages by exact name, official docs, RFCs,
  the relevant source files, book chapters). Verify links by fetching them when
  possible; if you cannot verify an exact URL, name the resource precisely rather
  than inventing a link.

## Rules

- Read-only: never edit files or run destructive/mutating commands. A quiz must
  not change the repo.
- No hints in questions (unless I ask); no spoilers - do not reveal an answer
  before I attempt it.
- Honest over nice: correct mistakes plainly. If the subject has something you
  cannot verify, say so and go find it rather than bluffing.
- One round at a time; always wait for me.
- ASCII only.
