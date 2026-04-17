# OMX CLI Default Skill

[English](./README.md)

这是 `omx-cli-default` 的独立仓库，供 Codex 桌面端调用 OMX 时使用。

主要能力：

- 任务群分级路由（`tiny` / `standard` / `complex`）
- OMX 优先执行与回传判定
- 闭环去重（OMX 已返回则不重复跑）
- OMX 回传缺失时由 Codex 自动补闭环

## 仓库结构

- `skills/omx-cli-default/SKILL.md`：技能契约与路由规则
- `skills/omx-cli-default/README.md`：运行说明
- `skills/omx-cli-default/scripts/`：执行脚本
- `PITCH.md`：项目介绍材料

## 快速使用

```bash
~/.codex/skills/omx-cli-default/scripts/omx_run_with_feedback.sh \
  --goal "<当前目标>" \
  --cluster auto \
  --omx "omx exec \"<任务>\"" \
  --report "<报告JSON路径>"
```

## 关联仓库

- Hermes skill: [hermes-ai-digest-skill](https://github.com/1pidandansolozhou/hermes-ai-digest-skill)
- Oceanus 主页: [oceanus-page](https://github.com/1pidandansolozhou/oceanus-page)
