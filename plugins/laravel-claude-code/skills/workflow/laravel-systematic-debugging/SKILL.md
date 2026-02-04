---
name: laravel-systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior in Laravel, before proposing fixes - requires root cause investigation first
---

# Laravel Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes.

**Announce at start:** "I'm using the laravel-systematic-debugging skill to investigate this issue."

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## The Four Phases

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

#### 1. Read Error Messages Carefully
```bash
# Check Laravel logs
cat storage/logs/laravel.log | tail -100

# Check specific error
grep -A 20 "ErrorType" storage/logs/laravel.log
```

- Don't skip past errors
- Read stack traces completely
- Note file paths and line numbers

#### 2. Reproduce Consistently
```bash
# Can you trigger it reliably?
php artisan test --filter="failing_test"

# Try in isolation
php artisan tinker
>>> $service->methodThatFails();
```

#### 3. Check Recent Changes
```bash
# What changed?
git diff HEAD~5

# Recent commits
git log --oneline -10
```

#### 4. Laravel-Specific Investigation

**For N+1 Query Issues:**
```php
// Enable query log
DB::enableQueryLog();
// ... run code ...
dd(DB::getQueryLog());
```

**For Queue Job Failures:**
```bash
php artisan queue:failed
php artisan queue:retry <id>
```

**For Auth Issues:**
```php
// Check auth state in tinker
>>> Auth::check();
>>> Auth::user();
>>> session()->all();
```

**For Route Issues:**
```bash
php artisan route:list --name=route.name
php artisan route:list --path=api/users
```

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

#### 1. Find Working Examples
```bash
# Search for similar working code
grep -r "similar_method" app/
```

#### 2. Compare Against Docs
- Check Laravel documentation for the feature
- Verify you're using the API correctly

#### 3. Identify Differences
- What's different between working and broken?
- List every difference, however small

### Phase 3: Hypothesis and Testing

**Scientific method:**

#### 1. Form Single Hypothesis
"I think X is the root cause because Y"

#### 2. Test Minimally
Make the SMALLEST possible change:
```php
// Add debug output
Log::debug('Value at this point', ['data' => $data]);

// Or use dd() for quick check
dd($suspectVariable);
```

#### 3. Verify Before Continuing
- Did it work? → Phase 4
- Didn't work? → New hypothesis
- DON'T add more fixes on top

### Phase 4: Implementation

**Fix the root cause:**

#### 1. Create Failing Test
```php
it('reproduces the bug', function () {
    // Setup that triggers the bug
    $result = $service->brokenMethod();

    // What should happen
    expect($result)->toBe('expected');
});
```

#### 2. Implement Single Fix
ONE change at a time.

#### 3. Verify Fix
```bash
php artisan test --filter="reproduces_the_bug"
php artisan test  # All tests still pass
```

## Laravel Debug Tools

### Telescope
```bash
# If installed, check Telescope dashboard
# http://your-app.test/telescope

# Check queries
# Check exceptions
# Check requests
```

### Tinker
```bash
php artisan tinker
>>> // Test in isolation
>>> $user = User::find(1);
>>> $service = app(UserService::class);
>>> $service->process($user);
```

### Logging
```php
// Different log levels
Log::debug('Debug info', ['context' => $data]);
Log::info('Info message');
Log::warning('Warning');
Log::error('Error', ['exception' => $e]);

// Check logs
tail -f storage/logs/laravel.log
```

### Database Debugging
```php
// Log all queries
DB::listen(function ($query) {
    Log::info($query->sql, $query->bindings);
});

// Check query
User::where('email', $email)->toSql();
```

## Common Laravel Issues

| Symptom | Likely Cause | Investigation |
|---------|--------------|---------------|
| 500 Error | Exception thrown | Check `storage/logs/laravel.log` |
| 404 Error | Route not found | `php artisan route:list` |
| 419 Error | CSRF token | Check `@csrf` in forms |
| 401 Error | Auth middleware | Check guards and middleware |
| N+1 Query | Missing eager load | Enable query log |
| Job failed | Queue exception | `php artisan queue:failed` |
| Model not found | Soft delete or ID | Check database directly |

## Red Flags - STOP

If you catch yourself thinking:
- "Quick fix for now"
- "Just try changing X"
- "It's probably this"
- "I don't fully understand but..."
- Proposing solutions before investigating

**ALL of these mean: STOP. Return to Phase 1.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple" | Simple issues have root causes too |
| "Emergency, no time" | Systematic is FASTER than guessing |
| "Just try this first" | First fix sets the pattern |
| "I see the problem" | Seeing symptoms ≠ understanding cause |

## Integration

**Related skills:**
- **laravel-tdd** - For creating failing test (Phase 4)
- **laravel-verification** - Verify fix before claiming success
