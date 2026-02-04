---
name: design-patterns
description: Laravel design patterns including Service Layer, Repository, Actions, and DTOs - activated when discussing architecture or code organization
version: 1.0.0
---

# Laravel Design Patterns

Guide for implementing clean architecture patterns in Laravel applications.

## When to Use

Activate this skill when:
- Refactoring fat controllers
- Organizing business logic
- Creating reusable code structures
- Improving testability
- Discussing architecture decisions

## Patterns Covered

### Service Layer (`service-layer.md`)
Encapsulate business logic in dedicated service classes.

**Use when:**
- Controller has more than 15 lines of business logic
- Same logic needed in multiple places
- Complex operations with multiple steps

### Repository Pattern (`repository-pattern.md`)
Abstract database operations behind interfaces.

**Use when:**
- Need to swap data sources
- Complex query logic that should be reusable
- Want to improve testability with mocks

## Quick Reference

### Fat Controller Problem
```php
// Before: Fat controller
public function store(Request $request) {
    $validated = $request->validate([...]);
    $user = User::create($validated);
    $user->assignRole('member');
    Mail::to($user)->send(new WelcomeEmail());
    event(new UserRegistered($user));
    return response()->json($user);
}

// After: Thin controller with service
public function store(StoreUserRequest $request, UserService $service) {
    $user = $service->register($request->validated());
    return new UserResource($user);
}
```

## Pattern Selection Guide

| Scenario | Recommended Pattern |
|----------|-------------------|
| Business logic in controller | Service Layer |
| Complex database queries | Repository |
| Single-purpose operations | Action Classes |
| Data transformation | DTO |
| Multiple implementations | Strategy |
