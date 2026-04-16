# OMX CLI Default Skill

A standalone Codex skill that enforces OMX CLI-first execution.

## 中文说明

### 这是什么

`omx-cli-default` 是一个用于 Codex 桌面工作流的策略型 skill。它把“任务怎么跑”标准化为可复用的执行规则：中大型任务优先走 OMX，新项目启动先做 OMX 引导，再进入任务执行。

### 应用场景

- 个人开发者需要稳定、可重复的任务执行节奏（尤其是多步骤任务）。
- 团队协作场景下，希望任务路由规则一致，降低成员风格差异。
- 需要频繁做调试、重构、代码审查、验证（测试/lint/typecheck）等中大型工作。
- 希望新项目开工时自动完成 OMX 初始化，避免“每次重新配环境”。

### 实现方式

- 任务分级门禁（Task Size Gate）：根据步骤数、是否改文件、是否需要验证、是否需要并行来判断任务规模。
- 新项目引导门禁（Bootstrap Gate）：进入新项目后，先执行 `omx init`，不支持时回退到 `omx deepinit .` 或 `omx agents-init .`。
- 命令路由策略：
  - `omx explore` 用于快速只读检索
  - `omx exec` 用于单线执行
  - `omx team` 用于并行实施
  - `omx resume --last` 用于恢复上下文
- 环境兼容回退：`omx` 不在 PATH 时自动切换 `npx omx`。

### 实用价值

- 提升一致性：不同任务、不同项目使用同一执行范式。
- 提升效率：减少“怎么执行”上的临时决策成本。
- 提升可靠性：把诊断、回退、恢复路径预先固化。
- 提升可维护性：规则集中在 skill 中，便于版本化迭代。

### 快速开始

```bash
omx setup --scope user
cd <project-root>
omx init
```

`omx init` 不可用时：

```bash
omx deepinit .
# or
omx agents-init .
```

若 `omx` 不在 PATH：

```bash
npx omx <command>
```

---

## English Guide

### What this is

`omx-cli-default` is a policy-oriented skill for Codex desktop workflows. It standardizes task execution by enforcing OMX-first routing for medium/large tasks and requiring OMX bootstrap when entering a new project.

### Application scenarios

- Solo developers who need repeatable execution patterns across multi-step tasks.
- Team workflows that need consistent routing rules across contributors.
- Engineering tasks with debugging, refactoring, review, or validation phases.
- New-project onboarding where OMX initialization should happen up front.

### How it works

- Task Size Gate: classifies work by step count, file edits, verification needs, and coordination complexity.
- Bootstrap Gate: runs `omx init` on project start, with compatibility fallback to `omx deepinit .` or `omx agents-init .`.
- Routing model:
  - `omx explore` for fast read-only discovery
  - `omx exec` for single-lane execution
  - `omx team` for coordinated parallel implementation
  - `omx resume --last` for context continuity
- Environment fallback: switches to `npx omx` when `omx` is not on PATH.

### Practical value

- Consistency: one execution model across projects.
- Efficiency: less decision overhead before doing real work.
- Reliability: built-in diagnostics and fallback paths.
- Maintainability: centralized, versioned workflow rules.

### Quick start

```bash
omx setup --scope user
cd <project-root>
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
- `skills/omx-cli-default/README.md`: operational bilingual guide
