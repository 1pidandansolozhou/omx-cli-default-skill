# Codex x OMX Bridge

Let Codex do more than code generation.
Let it automatically switch to OMX workflows when task complexity requires stronger execution control.

## What this project does

This skill addresses a practical gap in desktop Codex usage:
complex engineering tasks often outgrow direct single-thread conversational execution.

Once work involves multi-file changes, cross-module refactors, long command chains,
stable state handling, or orchestrated CLI execution,
Codex can still continue, but execution stability and throughput are not always optimal.

`Codex x OMX Bridge` introduces a routing layer:

- You describe the task in natural language.
- Codex evaluates task complexity.
- Complex tasks are upgraded to OMX CLI workflows automatically.
- Results are returned through the same Codex interface.

Users keep one interaction surface.
They do not need to manually switch tools or learn OMX commands first.

## Why this exists

Codex is excellent as a coding agent.
OMX is stronger for longer, stateful, orchestrated execution paths.

The real friction is not capability, but switching cost:
most users do not know when to move from Codex-first to OMX-first execution,
and even when they do, the handoff is manual and expensive.

This skill is not replacing Codex.
It is not repackaging OMX.
It is an execution-mode router.

## Core value proposition

### 1. Automatic complexity routing

Users do not need to decide whether to use OMX in advance.
The skill evaluates signals such as:

- repository/work scope size,
- multi-file or multi-module coupling,
- multi-step execution chains,
- need for CLI orchestration,
- need for stronger state continuity.

### 2. Expert workflow as default behavior

Experienced users already do this mentally:
small tasks go direct, larger tasks get planned and orchestrated.

This skill turns that implicit strategy into explicit, reusable product behavior.

### 3. Preserve Codex as the only user-facing entry

Users still talk only to Codex.
OMX runs in the background when needed.
No workflow fragmentation.

### 4. Built for real engineering tasks

Especially useful for:

- medium/large codebase transformations,
- coordinated multi-file edits,
- scan-before-execute tasks,
- tasks that combine testing/fixing/documentation,
- tasks requiring stable CLI execution chains.

## What this is not

This is not a new coding agent.
This is not a thin OMX launcher script.

It is an agent runtime selector / execution mode router:

- does not replace Codex,
- does not rebuild OMX,
- chooses the right execution paradigm for the current task.

## One-line summary

The value is not "Codex can launch OMX".
The value is "Codex can automatically choose a better execution mode when complexity increases".

---

## 中文版（产品首页说明）

### 它是做什么的

这个 skill 解决的是 Codex 桌面端的执行断层问题：
当任务进入多文件改动、跨模块重构、长链路执行、状态保持或 CLI 编排阶段时，
继续用单轮对话直接推进并不总是最优。

这个项目给 Codex 增加了一层执行模式路由能力：

- 用户仍然用自然语言提需求；
- Codex 自动判断任务复杂度；
- 复杂任务自动切到 OMX 执行；
- 结果再统一回流到 Codex 展示。

### 为什么要做这个

真正的问题不是“能不能做”，而是“什么时候该切换执行范式”。
这个切换如果靠用户手动完成，成本高且不稳定。

这个 skill 把切换动作产品化：

- 简单任务：Codex 直跑；
- 复杂任务：自动升级 OMX；
- 用户始终只有一个对话入口。

### 核心价值

1. 自动判断，不要求用户手动切工具。
2. 把高手工作流（先判断复杂度再执行）变成默认能力。
3. 保留 Codex 自然语言入口，不增加工具心智负担。
4. 面向真实工程任务而非演示级任务。

### 最适合谁

- 已经在用 Codex，但经常处理复杂项目的人。
- 对 OMX 感兴趣，但不希望每次手动接管 CLI 的人。

### 一句话总结

这个 skill 补上的不是能力空白，而是工作流切换的断层。

---

## English opener for GitHub profile usage

Codex x OMX Bridge helps Codex choose execution mode instead of only generating code.
Small tasks stay conversational.
Complex tasks are automatically upgraded to OMX orchestration.
One natural-language interface, better execution for real engineering work.

## Human pitch (30-second)

Codex is great at coding, and OMX is great at orchestrating heavier workflows.
Most people lose time on the handoff between the two.
This project removes that handoff.
It lets Codex detect when a task becomes complex and automatically route execution to OMX,
while users continue talking to a single interface.
So the user experience stays simple, but execution gets significantly stronger.

## Quick links

- Skill contract: [`skills/omx-cli-default/SKILL.md`](./skills/omx-cli-default/SKILL.md)
- Operational guide: [`skills/omx-cli-default/README.md`](./skills/omx-cli-default/README.md)
- Pitch-only version: [`PITCH.md`](./PITCH.md)
