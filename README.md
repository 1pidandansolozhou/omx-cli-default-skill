# OMX CLI Default Skill

Standalone repository for a Codex skill that enforces an OMX CLI-first workflow.

## What this skill enforces

- Medium/large tasks must run through OMX CLI.
- New project start must run OMX bootstrap before substantive work.
- Tiny one-step tasks may skip OMX only when overhead is unnecessary.

## Install into local Codex skills

```bash
# from this repository root
mkdir -p "$HOME/.codex/skills/omx-cli-default"
cp skills/omx-cli-default/SKILL.md "$HOME/.codex/skills/omx-cli-default/SKILL.md"
```

Windows PowerShell example:

```powershell
$target = "$env:USERPROFILE\.codex\skills\omx-cli-default"
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -LiteralPath ".\skills\omx-cli-default\SKILL.md" -Destination "$target\SKILL.md" -Force
```

## OMX baseline commands

```bash
omx setup --scope user
omx init
```

Fallback when `omx init` is unavailable:

```bash
omx deepinit .
# or
omx agents-init .
```

If `omx` is not on PATH:

```bash
npx omx <command>
```

## Repository layout

- `skills/omx-cli-default/SKILL.md`: executable skill contract
- `skills/omx-cli-default/README.md`: behavior and routing details
