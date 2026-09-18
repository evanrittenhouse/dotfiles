---
name: harness-engineering
description: Design and review agent harnesses, skills, prompts, delegation, context packaging, tool loops, and feedback workflows with attention to token efficiency and reliable boundaries. Use for agent orchestration and harness design, not ordinary application code.
---

# Harness Engineering

Design agent workflows that spend context, delegation, and tool calls only when they improve the result.

## Context is a resource

- Give each agent the smallest sufficient context for its task.
- Package the relevant inputs, decisions, constraints, and output contract explicitly.
- Prefer context-free delegation with a scoped task over replaying a full transcript.
- Include full conversation context only when the task genuinely depends on decisions or relationships that cannot be represented reliably in a focused handoff.
- Preserve source text verbatim only when fidelity is part of the task. Summarize background that merely helps orientation.

## Delegation must earn its cost

- Delegate when an independent assessment, parallel work, isolation, or specialized focus materially improves the outcome.
- Account for the tokens, latency, coordination, and verification introduced by delegation.
- Perform narrow work directly when preparing and supervising a subagent costs more than the work itself.
- Prevent recursive delegation unless the workflow explicitly needs a delegation tree and budgets for it.
- State who owns the artifact, who verifies it, and when the parent may report completion.

## Define an executable contract

A delegated task should identify its inputs, scope, authority, destination, output format, and acceptance checks. Exclude unrelated history and implementation detail. Make failure and fallback behavior explicit when an unavailable capability would otherwise change the workflow.

Verify the observable artifact or result after delegation. A subagent's completion statement is evidence to inspect, not a substitute for inspection.

## Keep runtime metadata in agent home

Place runtime metadata that a skill reads or produces under `~/.agents`, including feedback examples, review queues, traces, and skill-specific working state. Treat source repositories as homes for deployable skill definitions and `~/.agents` as the stable runtime boundary, so installed skills operate independently of the repository used to develop them.

## Incorporate feedback carefully

Examples under `~/.agents/examples/harness-engineering` are candidate evidence for improving this skill. Review the corrected output, user guidance, and assessment together. Distill the narrow reusable principle, preserve important exceptions, and avoid turning one failure into a universal rule.
