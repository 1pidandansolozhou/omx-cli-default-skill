# OMX CLI Default - Bilingual Operational Guide

## 中文说明

### 适用场景

- 任务包含多个阶段：检索、修改、验证、回归检查。
- 任务需要跨文件改动或需要稳定的执行节奏。
- 任务存在协作需求，需要可预测的并行处理方式。
- 新项目开工，需要先完成 OMX 初始化再执行任务。

### 规则实现（执行决策树）

1. 判断任务规模。

满足任一条件即判定为中大型任务（强制 OMX）：
- 需要 2 步及以上的实质性操作。
- 需要修改代码或配置文件。
- 需要验证（测试、lint、typecheck、诊断）。
- 涉及调试、重构、审查或并行协调。

2. 新项目启动门禁。

优先执行：

```bash
cd <project-root>
omx init
```

若 `init` 不可用：

```bash
omx deepinit .
# or
omx agents-init .
```

3. 执行路由。

```bash
omx explore --prompt "<lookup>"
omx exec "<single-lane task>"
omx team N:executor "<parallel implementation task>"
omx resume --last
```

4. 环境回退。

`omx` 不在 PATH 时使用：

```bash
npx omx <command>
```

5. 恢复与诊断。

```bash
omx doctor
omx setup --scope user --force
```

### 实用价值

- 把“执行流程”从个人习惯升级为可复用策略。
- 减少临时判断，提升交付速度和稳定性。
- 在跨项目迁移时保持一致的认知与操作模型。
- 降低新项目起步成本，减少初始化遗漏。

---

## English Guide

### Use cases

- Work that spans discovery, edits, validation, and follow-up checks.
- Tasks that modify multiple files or require predictable execution cadence.
- Collaboration-heavy tasks that benefit from structured parallel lanes.
- New-project onboarding where OMX bootstrap should happen first.

### Implementation model (decision tree)

1. Classify task size.

A task is medium/large (OMX-mandatory) if any applies:
- Two or more meaningful execution steps.
- Code or config changes are required.
- Verification is required (tests, lint, typecheck, diagnostics).
- Debugging, refactoring, review, or coordination is required.

2. Enforce new-project bootstrap.

Preferred:

```bash
cd <project-root>
omx init
```

Fallback:

```bash
omx deepinit .
# or
omx agents-init .
```

3. Route execution.

```bash
omx explore --prompt "<lookup>"
omx exec "<single-lane task>"
omx team N:executor "<parallel implementation task>"
omx resume --last
```

4. Apply environment fallback.

Use `npx omx` when `omx` is not on PATH.

5. Recover and diagnose.

```bash
omx doctor
omx setup --scope user --force
```

### Practical value

- Converts execution behavior from personal habit into reusable policy.
- Reduces decision overhead before implementation.
- Preserves consistency across projects and contributors.
- Lowers startup friction for new repositories.
