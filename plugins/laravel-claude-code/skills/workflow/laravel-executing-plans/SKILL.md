---
name: laravel-executing-plans
description: Use when you have a written implementation plan to execute with batch checkpoints and verification
---

# Laravel Plan Execution

## Overview

Load plan, review critically, execute tasks in batches, verify and report between batches.

**Core principle:** Batch execution with verification checkpoints.

**Announce at start:** "I'm using the laravel-executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan

1. Read plan file
2. Review critically - identify questions or concerns
3. If concerns: Raise them before starting
4. If no concerns: Create task list and proceed

### Step 2: Execute Batch

**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (TDD: RED → GREEN → REFACTOR)
3. Run verifications as specified
4. Commit after each task
5. Mark as completed

### Step 3: Verify Batch

After each batch:

```bash
php artisan test
./vendor/bin/pint --test
./vendor/bin/phpstan analyse
```

### Step 4: Report

```markdown
## Batch 1 Complete (Tasks 1-3)

### Implemented
- Task 1: User migration and model
- Task 2: User registration endpoint
- Task 3: User login endpoint

### Verification
✅ Tests: 12 passed, 0 failed
✅ Pint: PASS
✅ PHPStan: No errors

Ready for feedback before next batch.
```

### Step 5: Continue or Complete

Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

When all tasks done:
- Run full verification
- Report completion

## Task Execution Pattern

For each task:

```
1. Read task from plan
2. Create/modify files as specified
3. Follow TDD steps:
   - Write failing test
   - Run test (confirm RED)
   - Write implementation
   - Run test (confirm GREEN)
   - Refactor if needed
4. Run task-level verification
5. Commit with conventional message
6. Mark task complete
```

## When to Stop and Ask

**STOP executing when:**
- Test fails unexpectedly
- Missing dependency or configuration
- Plan instruction is unclear
- Verification fails repeatedly
- Blocker mid-batch

**Ask for clarification rather than guessing.**

## Verification Commands

### Per Task
```bash
php artisan test --filter="TaskSpecificTest"
```

### Per Batch
```bash
php artisan test
./vendor/bin/pint --test
```

### Final
```bash
php artisan test
./vendor/bin/pint --test
./vendor/bin/phpstan analyse
php artisan route:list --except-vendor
```

## Example Execution

```
You: I'm using the laravel-executing-plans skill.

[Read plan: docs/plans/2024-01-15-user-auth.md]
[Review: 5 tasks, no concerns]

Starting Batch 1 (Tasks 1-3)...

Task 1: Database Setup
- Created migration: users table
- Created model: User.php
- Test: ✅ passes
- Committed: "feat(users): add user migration and model"

Task 2: Registration Endpoint
- Created test: UserRegistrationTest
- Test RED: ✅ fails as expected
- Created controller and route
- Test GREEN: ✅ passes
- Committed: "feat(auth): add registration endpoint"

Task 3: Login Endpoint
- Created test: UserLoginTest
- Test RED: ✅ fails as expected
- Implemented login logic
- Test GREEN: ✅ passes
- Committed: "feat(auth): add login endpoint"

Batch 1 Verification:
✅ php artisan test - 8 passed
✅ pint --test - PASS

Ready for feedback.
```

## Red Flags

**Never:**
- Skip TDD steps
- Proceed with failing tests
- Make changes not in plan
- Skip batch verification
- Commit without tests passing

**Always:**
- Follow plan exactly
- Verify after each batch
- Report progress clearly
- Stop when blocked

## Integration

**Input from:**
- **laravel-planning** - Creates the plan this skill executes

**Uses:**
- **laravel-tdd** - TDD cycle for each task
- **laravel-verification** - Verification between batches
