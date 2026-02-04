---
description: Start systematic debugging workflow for Laravel issues
argument-hint: <error-description>
disable-model-invocation: true
---

# Laravel Debug

Start a systematic 4-phase debugging workflow for any Laravel issue.

## Usage

```
/debug 500 error on user registration
/debug tests failing after model changes
/debug queue jobs not processing
/debug N+1 query on posts index
```

## Workflow

1. **Phase 1: Root Cause Investigation** - Read errors, reproduce, check changes
2. **Phase 2: Pattern Analysis** - Find working examples, compare
3. **Phase 3: Hypothesis Testing** - Form theory, test minimally
4. **Phase 4: Implementation** - Create failing test, fix, verify

Invoke the laravel-systematic-debugging skill and follow it exactly as presented.

**Error description:** $ARGUMENTS
