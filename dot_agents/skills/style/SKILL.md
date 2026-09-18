---
name: style
description: Apply preferred terminology and code-comment style when writing or reviewing code comments and technical status messages. Comments describe current behavior plainly and avoid history, derivation narratives, and descriptions of behavior the code does not perform.
---

# Technical Style

When writing, editing, or reviewing code comments:

- Describe the code as it exists and the behavior it performs.
- Use direct, positive statements about what the code does.
- Do not record previous implementations, superseded states, migrations, or the process by which the current implementation was derived. Those are history and belong in version control or design documentation.
- Do not describe behavior that is absent from the code or draw attention to what the code does not do.
- When rationale is useful, explain the current constraint or invariant that shapes the implementation without narrating its history.
- Rewrite historical or negative contrasts as plain descriptions of current behavior.
- Naming both supported alternatives is useful when it clarifies a choice or distinction the reader needs to understand. This is especially helpful for booleans or predicates where the code names one alternative and leaves the other implicit. For example, `Whether the foreground command uses PTY or piped stdin` explicitly names the piped-stdin alternative that a PTY predicate leaves implicit. Keep such comparisons; the guidance against negative contrasts concerns irrelevant alternatives and absent behavior.

For example, prefer `Returns the first error from the backend` over `This no longer retries backend errors`, and prefer `Uses the workspace cache for build outputs` over `Previously this used the global cache`.

## Commonly used phrases thesaurus

Use the preferred term when both words describe the same state in a code comment or technical status message.

| Phrase | Preferred term |
| --- | --- |
| `wedged` | `blocked` |
| `load-bearing` | `key` |

Use `load-bearing` when `key` already denotes cryptographic keys in the same context.
