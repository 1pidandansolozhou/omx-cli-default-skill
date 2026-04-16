---
name: omx-cli-default
description: Enforce OMX CLI-first execution for user-directed work. Use when the user wants OMX-driven execution, when tasks are medium/large multi-step work, when a new project session starts, or when one-time Codex config injection via `omx setup --scope user` or `omx setup --scope project` is needed.
---

# OMX CLI Default

## Objective

Run user-directed work through OMX CLI by default.
Treat medium/large tasks as OMX-mandatory.
Trigger OMX bootstrap on every new project start.

## Hard Rules

1. Medium/large tasks must use OMX.
2. New project start must run OMX bootstrap before task execution.
3. Tiny one-step tasks may run directly only when OMX overhead is unnecessary.

## Task Size Gate

Treat a task as medium/large (OMX mandatory) if any condition is true:

- Requires 2 or more meaningful steps.
- Changes code or config files.
- Requires verification (tests, lint, typecheck, diagnostics).
- Requires investigation/debugging/refactoring/review.
- Requires parallel lanes or coordination.

Treat a task as tiny only when all are true:

- Single-step, no file edits, no multi-command workflow.
- No branching decisions or dependency checks.
- No validation phase required.

## Command Resolution

Use `omx` when available on PATH.
Use `npx omx` when `omx` is unavailable on PATH.
Keep arguments identical after substitution.

## New Project Bootstrap Gate

Before running substantive work in a new project:

```bash
cd <project-root>
omx init
```

If `omx init` is unavailable in the installed version:

```bash
cd <project-root>
omx deepinit .
```

If `deepinit` is unavailable:

```bash
cd <project-root>
omx agents-init .
```

Then continue task execution via OMX commands.

## OMX Command Routing

- Read-only fast lookup:

```bash
omx explore --prompt "<lookup>"
```

- Single-lane execution:

```bash
omx exec "<task>"
```

- Coordinated parallel execution for larger implementation lanes:

```bash
omx team N:executor "<task>"
```

- Continue prior OMX context when appropriate:

```bash
omx resume --last
```

## Setup Policy

For one-time global install/config injection:

```bash
omx setup --scope user
```

Use project-only scope only on explicit request:

```bash
omx setup --scope project
```

## Recovery Policy

When OMX behavior is unexpected:

```bash
omx doctor
```

If wiring is stale or partially broken:

```bash
omx setup --scope user --force
```

## Execution Behavior

- Treat user instruction as source of truth.
- Translate instruction into OMX CLI commands and execute directly.
- Do not ask for confirmation on obvious reversible steps.
- Keep going until verified complete or hard blocked.

## Output Contract

Always report:

1. OMX commands executed.
2. Key result and verification evidence.
3. Blocker and next OMX action if incomplete.
