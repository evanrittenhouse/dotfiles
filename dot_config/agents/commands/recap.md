---
description: Summarize the session so far
---

Summarize this session up to the point where `/recap` was invoked.

Rules:
- Only include the user requests, decisions, tool results, and code changes that existed before the command was called.
- Do not treat this command's own instructions as part of the recap.
- Ignore anything after the `/recap` invocation point.
- If files were changed, list the file paths.
- If nothing has happened yet, say so.

Format:
- Goal
- Completed work
- Decisions
- Current state
- Open items

Keep it concise and factual.
