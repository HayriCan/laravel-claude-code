---
description: Start TDD cycle with Pest PHP (RED-GREEN-REFACTOR)
argument-hint: <test-description>
disable-model-invocation: true
---

# Laravel TDD

Start a Test-Driven Development cycle for implementing a feature or fixing a bug.

## Usage

```
/tdd user registration with email verification
/tdd post creation with image upload
/tdd fix: order total calculation bug
```

## Workflow

1. **RED** - Write failing test first
2. **Verify RED** - Run test, confirm it fails correctly
3. **GREEN** - Write minimal code to pass
4. **Verify GREEN** - Run test, confirm it passes
5. **REFACTOR** - Clean up while keeping green

Invoke the laravel-tdd skill and follow it exactly as presented.

**Test description:** $ARGUMENTS
