# OMX CLI Default - Operational Guide (CN + EN)

## 中文说明

### 应用场景

- 多步骤任务（检索、修改、验证、回归）
- 多文件或跨模块联动改造
- 需要稳定 CLI 链路和状态保持
- 需要并行执行与更明确的任务编排

### 实现方式

1. 任务分级（Task Size Gate）

满足任一条件即触发 OMX：

- 两步及以上的实质操作
- 涉及代码/配置文件修改
- 需要测试/lint/typecheck/诊断
- 涉及调试、重构、评审或并行协作

2. 新项目门禁（Bootstrap Gate）

优先：

```bash
cd <project-root>
omx init
```

兼容回退：

```bash
omx deepinit .
# or
omx agents-init .
```

3. 路由策略

```bash
omx explore --prompt "<lookup>"
omx exec "<single-lane task>"
omx team N:executor "<parallel implementation task>"
omx resume --last
```

4. PATH 回退

`omx` 不在 PATH 时使用 `npx omx <command>`。

5. 恢复策略

```bash
omx doctor
omx setup --scope user --force
```

### 实用价值

- 一致性：跨任务、跨项目统一执行范式
- 稳定性：复杂任务获得更强编排与状态管理
- 效率：减少用户手动切换工具的决策成本
- 可维护性：策略固化到 skill，便于版本化演进

---

## English Guide

### Typical use cases

- Multi-step tasks with discovery, edit, validation, and follow-up
- Cross-file or cross-module changes
- Work requiring stable CLI chains and persistent execution state
- Coordination-heavy implementation that benefits from parallel lanes

### Execution model

1. Task Size Gate

OMX becomes mandatory when any condition applies:

- 2+ meaningful steps
- code/config edits
- verification (tests/lint/typecheck/diagnostics)
- debugging/refactoring/review/coordination

2. Bootstrap Gate

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

3. Routing

```bash
omx explore --prompt "<lookup>"
omx exec "<single-lane task>"
omx team N:executor "<parallel implementation task>"
omx resume --last
```

4. PATH fallback

Use `npx omx <command>` when `omx` is not available on PATH.

5. Recovery

```bash
omx doctor
omx setup --scope user --force
```

### Practical value

- Consistent execution mode across projects
- Stronger reliability on complex engineering tasks
- Lower switching overhead for users
- Better maintainability through versioned workflow policy
