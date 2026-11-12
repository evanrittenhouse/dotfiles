---
name: condense
description: Review a fleshed-out engineering change against existing codebase patterns and identify substitutions that reduce duplication and accidental complexity without weakening correctness or clarity. Use after the basic design or implementation exists and before submission, not for initial design.
---

# Condense

Review a developed change for opportunities to express it with patterns the codebase already uses. The goal is a smaller conceptual surface and a more coherent codebase, not merely fewer lines.

## Establish the review target

- Use the change, diff, branch, or design identified by the user. Otherwise, review the current working-tree and branch changes.
- Treat the change as the review surface and the broader codebase as the comparison corpus. Keep unrelated pre-existing code out of scope.
- Understand the intended behavior and constraints from the implementation, call sites, tests, and nearby documentation before proposing substitutions.
- If there is no concrete design or change to inspect, explain what review target is missing instead of performing initial design under this skill.

## Compare patterns by responsibility

Inventory the patterns introduced by the change, including data representations, control flow, helper functions, abstractions, error handling, validation, configuration, lifecycle management, concurrency, and test infrastructure.

Search the repository for code that serves the same responsibility, even when its names or syntax differ. Inspect the existing implementation, its callers, and its tests closely enough to understand its guarantees and limitations. Prefer established patterns near the changed subsystem when several analogues exist, while respecting repository-wide conventions and dependency boundaries.

## Recommend only safe condensation

Recommend substituting an existing pattern when it:

- Preserves the change's behavior, invariants, edge cases, and operational properties.
- Removes duplicated logic, parallel mechanisms, or unnecessary concepts.
- Fits the existing ownership and dependency direction.
- Keeps the code at least as readable and structurally clear.
- Can be verified with focused tests or other concrete evidence.

Do not recommend reuse based on surface similarity alone. Separate implementations are appropriate when semantics, lifecycle, ownership, performance, or failure handling differ. Avoid widening an existing abstraction or creating a new generic layer merely to eliminate a small amount of duplication.

Prefer direct reuse or a small adaptation of an established pattern over introducing another abstraction that both implementations must depend on.

## Report the review

Report findings in descending order of impact. For each finding, identify:

- The pattern introduced by the change and its location.
- The existing analogue and its location.
- The concrete substitution or simplification.
- Why it preserves correctness and improves coherence.
- Any risks, semantic differences, and validation needed.

Distinguish worthwhile substitutions from optional stylistic alignment. If no safe substitutions exist, say so and name the relevant patterns compared. Review and report by default; modify the change only when the user asks for implementation.
