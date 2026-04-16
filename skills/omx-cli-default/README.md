# OMX CLI Default - Skill Notes

## Policy

- Medium/large tasks are OMX-mandatory.
- New project start always triggers OMX bootstrap.
- Tiny one-step tasks may run directly only when OMX overhead is unnecessary.

## Medium/large gate

Use OMX if any condition is true:

- Multi-step workflow is required.
- File modifications are required.
- Validation is required (tests/lint/typecheck/diagnostics).
- Debugging/refactoring/review work is required.
- Parallel lanes are beneficial.

## Bootstrap gate

Preferred:

```bash
cd <project-root>
omx init
```

Compatibility fallback:

```bash
omx deepinit .
# or
omx agents-init .
```

## Routing

```bash
omx explore --prompt "<lookup>"
omx exec "<single-lane task>"
omx team N:executor "<parallel implementation task>"
omx resume --last
```

## PATH fallback

Use `npx omx` when `omx` is not on PATH.

## Recovery

```bash
omx doctor
omx setup --scope user --force
```
