---
description: Execute Laravel implementation plan in batches with verification checkpoints
argument-hint: [plan-file-path]
disable-model-invocation: true
---

# Execute Laravel Plan

Execute a written implementation plan with batch checkpoints and verification.

## Usage

```
/execute-plan
/execute-plan docs/plans/2024-01-15-user-auth.md
```

## Workflow

1. **Load** - Read and review plan
2. **Execute** - Run tasks in batches of 3
3. **Verify** - Run tests and linting after each batch
4. **Report** - Show progress and wait for feedback
5. **Repeat** - Continue until all tasks complete

If no plan file specified, looks for most recent plan in `docs/plans/`.

Invoke the laravel-executing-plans skill and follow it exactly as presented.

**Plan file:** $ARGUMENTS
