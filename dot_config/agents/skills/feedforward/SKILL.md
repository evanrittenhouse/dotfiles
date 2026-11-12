---
name: feedforward
description: Capture a user's correction of an assistant response as a reviewable example. Use when the user invokes feedforward, requests ff, or asks to record feedforward from the current conversation.
---

# Feedforward

Capture one correction example without changing the work being assessed.

## Establish the scope

- Treat the message that invoked this skill as the boundary for the user's guidance.
- Use the assistant response immediately before the invocation as the output being corrected unless the user explicitly identifies another response.
- For an inline invocation, treat the correction text after the skill name or invocation token as the guidance. Omit the name or token itself while preserving the correction text verbatim.
- Use messages before the invocation only to recover that output and the context needed to assess it. Do not treat older conversation as additional guidance.
- Preserve the corrected output and the user's guidance verbatim. Do not silently improve, summarize, or reinterpret either one.

## Classify the example

Choose one related-skill directory before the assessment:

- Use an existing skill name when the guidance should change or reinforce that skill.
- Use `harness-engineering` for reusable principles about skills, prompts, delegation, context, token use, tool loops, or agent orchestration, even when the issue surfaced while building another skill.
- Use `unassigned` when no existing skill is a defensible fit. Do not invent a category or create a skill merely to file an example.

Use the selected category in the artifact destination, including in any delegated task.

## Delegate the assessment

If delegation is available and permitted, create one subagent without inherited conversation context. Use the current tool's option for a fresh context. Do not fork or reload the conversation. Put only the following material in its task:

- The corrected assistant output, verbatim.
- The user's guidance, verbatim.
- The example format, destination, and review-queue instructions below.
- An instruction to assess the correction directly without further delegation.

The subagent owns the assessment, example file, and review-queue update. Wait for it to finish before reporting completion. If delegation is unavailable, not permitted, or cannot limit context to this task, perform the same work directly. Never give a feedforward subagent the full conversation.

Analyze only the scoped correction. The assessment is subjective: explain how the guidance applies to the output, what specifically should change, and any nuance that prevents the guidance from being overgeneralized.

## Write the example

Create a Markdown file under the selected related-skill directory:

```text
~/.agents/examples/<related-skill>
```

Resolve `~` for the current user and create the related-skill directory when it does not exist. This is private runtime state and must remain outside development repositories.

Name the file `YYYY-MM-DD-HHMMSS-<short-slug>.md` using local time and a short topic slug. If that name exists, add a numeric suffix.

The file contains exactly these three top-level sections:

```markdown
## Output being corrected

> Verbatim assistant output, with every line quoted.

## User guidance

> Verbatim user guidance, with every line quoted.

## Assessment

The subjective assessment.
```

Quote blank lines as `>` so Markdown from the transcript stays nested inside its section.

## Queue it for review

Append exactly one unchecked Markdown checklist item to:

```text
~/.agents/to-be-reviewed.md
```

Resolve `~` and use the resulting absolute path in the link to the new example:

```markdown
- [ ] [<filename>](<resolved-absolute-example-path>)
```

Do not add a duplicate queue entry. Verify that the example exists and the queue contains its link, then report both paths to the user.
