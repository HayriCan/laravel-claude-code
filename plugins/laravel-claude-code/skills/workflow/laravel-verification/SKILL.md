---
name: laravel-verification
description: Use when about to claim work is complete, before committing or creating PRs - requires running verification commands and confirming output
---

# Laravel Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Announce at start:** "I'm running Laravel verification checks."

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification commands in this message, you cannot claim it passes.

## Verification Checklist

### 1. Tests

```bash
php artisan test
```

**Must see:** `Tests: X passed (0 failed)`

### 2. Code Style (Pint)

```bash
./vendor/bin/pint --test
```

**Must see:** `PASS` or fix reported issues first.

### 3. Static Analysis (PHPStan)

```bash
./vendor/bin/phpstan analyse
```

**Must see:** `[OK] No errors`

### 4. Routes

```bash
php artisan route:list --except-vendor
```

**Check:** New routes registered correctly.

### 5. Migrations

```bash
php artisan migrate:status
```

**Check:** All migrations ran.

## Quick Verification Command

Run all at once:

```bash
php artisan test && ./vendor/bin/pint --test && ./vendor/bin/phpstan analyse
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| "Tests pass" | `php artisan test` output: 0 failed | "Should pass" |
| "Code is clean" | `pint --test` output: PASS | "Looks fine" |
| "No errors" | `phpstan` output: No errors | "I checked" |
| "Bug fixed" | Test for bug passes | Code changed |
| "Feature complete" | All checklist items green | "Tests pass" |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification
- About to commit without verification
- Relying on previous run
- "Just this once"

## Verification Report Template

```markdown
## Verification Report

### Tests
✅ `php artisan test` - 47 passed, 0 failed

### Code Style
✅ `./vendor/bin/pint --test` - PASS

### Static Analysis
✅ `./vendor/bin/phpstan analyse` - No errors

### Routes
✅ New routes registered: POST /api/users, GET /api/users/{id}

### Migrations
✅ All migrations ran: 2024_01_15_create_users_table

**Status:** Ready for commit/PR
```

## When to Run

**ALWAYS before:**
- Committing code
- Creating PR
- Claiming task complete
- Moving to next task
- Reporting progress

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Tests passed earlier" | Run again, now |
| "Minor change, no need" | Minor changes break things |

## Integration

**Related skills:**
- **laravel-tdd** - TDD ensures tests exist
- **laravel-executing-plans** - Verification between batches

**Called after:**
- Every task completion
- Before every commit
