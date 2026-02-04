---
description: Comprehensive Laravel code review with architecture, security, and best practices analysis
argument-hint: [file-or-directory] [--focus=architecture|security|eloquent|all]
---

# Laravel Code Review

Perform a comprehensive code review following Laravel best practices.

## Usage

```
/laravel-review                          # Review recent changes (git diff)
/laravel-review app/Http/Controllers     # Review specific directory
/laravel-review app/Models/User.php      # Review specific file
/laravel-review --focus=security         # Focus on security issues
/laravel-review --focus=eloquent         # Focus on database/Eloquent
```

## Review Scope

When no arguments provided, review files from `git diff HEAD~1`.

## Checklist

### Architecture
- Controllers are thin (delegate to services)
- Business logic in dedicated classes
- Proper dependency injection
- Single responsibility principle

### Eloquent
- Eager loading used (no N+1)
- Query scopes for reusable conditions
- Proper relationship definitions
- Index recommendations

### Security
- Form Requests for validation
- Policies for authorization
- No SQL injection vulnerabilities
- Mass assignment protection

### Testing
- Adequate test coverage
- Proper use of factories
- Edge cases covered

## Output

Generates a structured report with:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (nice to have)
- Positive highlights
- Overall metrics

Launch the `laravel-reviewer` agent with scope: $ARGUMENTS
