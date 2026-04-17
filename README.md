# OMX CLI Default Skill

[简体中文](./README.zh-CN.md)

Standalone repository for the `omx-cli-default` skill used by Codex desktop.

It provides:

- adaptive task-cluster routing (`tiny` / `standard` / `complex`)
- OMX-first execution handoff
- idempotent close-loop behavior (reuse OMX artifacts when already returned)
- fallback close-loop by Codex when OMX output is incomplete

## Repository Layout

- `skills/omx-cli-default/SKILL.md`: skill contract and routing rules
- `skills/omx-cli-default/README.md`: operational details
- `skills/omx-cli-default/scripts/`: runtime scripts
- `PITCH.md`: product pitch material

## Quick Use

```bash
~/.codex/skills/omx-cli-default/scripts/omx_run_with_feedback.sh \
  --goal "<current-goal>" \
  --cluster auto \
  --omx "omx exec \"<task>\"" \
  --report "<report-json-path>"
```

## Related Repositories

- Hermes skill: [hermes-ai-digest-skill](https://github.com/1pidandansolozhou/hermes-ai-digest-skill)
- Oceanus site: [oceanus-page](https://github.com/1pidandansolozhou/oceanus-page)
