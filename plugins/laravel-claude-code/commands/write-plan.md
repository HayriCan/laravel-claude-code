---
description: Create detailed Laravel implementation plan with TDD steps
argument-hint: <feature-name>
disable-model-invocation: true
---

# Write Laravel Plan

Create a detailed implementation plan for a Laravel feature with bite-sized TDD tasks.

## Usage

```
/write-plan user-authentication
/write-plan blog-posts-crud
/write-plan payment-integration
```

## Output

Creates `docs/plans/YYYY-MM-DD-<feature-name>.md` with:
- Task breakdown (2-5 min each)
- Exact file paths
- Complete code snippets
- TDD steps (RED-GREEN-REFACTOR)
- Verification commands

Invoke the laravel-planning skill and follow it exactly as presented.

**Feature name:** $ARGUMENTS
