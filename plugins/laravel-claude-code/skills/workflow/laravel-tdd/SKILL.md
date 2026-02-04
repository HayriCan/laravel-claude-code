---
name: laravel-tdd
description: Use when implementing any feature or bugfix in Laravel, before writing implementation code - enforces RED-GREEN-REFACTOR with Pest PHP
---

# Laravel Test-Driven Development

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

**Announce at start:** "I'm using the laravel-tdd skill for RED-GREEN-REFACTOR."

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

## Red-Green-Refactor Cycle

### RED - Write Failing Test

```php
// tests/Feature/UserRegistrationTest.php
it('creates a user with valid data', function () {
    // Arrange
    $data = [
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'password123',
    ];

    // Act
    $response = $this->postJson('/api/register', $data);

    // Assert
    $response->assertCreated();
    $this->assertDatabaseHas('users', ['email' => 'john@example.com']);
});
```

**Requirements:**
- One behavior per test
- Clear descriptive name
- AAA pattern (Arrange-Act-Assert)

### Verify RED

```bash
php artisan test --filter="creates a user with valid data"
```

**Confirm:**
- Test FAILS (not errors)
- Failure message is expected
- Fails because feature is missing

### GREEN - Minimal Code

Write **simplest code** to pass:

```php
// app/Http/Controllers/AuthController.php
public function register(Request $request)
{
    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'password' => Hash::make($request->password),
    ]);

    return response()->json($user, 201);
}
```

**Don't:**
- Add features not tested
- Refactor other code
- Add validation (test it first!)

### Verify GREEN

```bash
php artisan test --filter="creates a user with valid data"
```

**Confirm:** Test passes.

### REFACTOR

Only after green:
- Extract to Service class
- Add Form Request
- Improve naming

**Keep tests green throughout.**

## Laravel-Specific Patterns

### Feature vs Unit Tests

| Type | Location | Purpose |
|------|----------|---------|
| Feature | `tests/Feature/` | HTTP, database, full stack |
| Unit | `tests/Unit/` | Isolated class logic |

### Database Testing

```php
uses(RefreshDatabase::class);

it('stores a post', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/posts', ['title' => 'Test']);

    $response->assertCreated();
    $this->assertDatabaseHas('posts', ['title' => 'Test']);
});
```

### Validation Testing

```php
it('requires email for registration', function () {
    $response = $this->postJson('/api/register', [
        'name' => 'John',
        'password' => 'password123',
    ]);

    $response->assertUnprocessable()
        ->assertJsonValidationErrors(['email']);
});
```

### Authorization Testing

```php
it('forbids non-admin from deleting users', function () {
    $user = User::factory()->create();
    $target = User::factory()->create();

    $response = $this->actingAs($user)
        ->deleteJson("/api/users/{$target->id}");

    $response->assertForbidden();
});
```

## Test Checklist

Every feature should test:
- [ ] Happy path (success)
- [ ] Validation failures (422)
- [ ] Authentication (401)
- [ ] Authorization (403)
- [ ] Not found (404)
- [ ] Edge cases

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Validation is obvious" | Test it. Laravel validation has quirks. |
| "Factory handles it" | Factory tests factory. Test your code. |
| "TDD slows me down" | Debugging untested code is slower. |

## Red Flags - STOP

- Code written before test
- Test passes immediately
- Multiple features per test
- Skipping validation tests
- "I'll add tests later"

**All mean:** Delete code. Start over with TDD.

## Integration

**Related skills:**
- **laravel-verification** - Run full verification before completion
- **laravel-planning** - Plans include TDD steps

**Commands:**
- `php artisan test` - Run all tests
- `php artisan test --filter=TestName` - Run specific test
- `php artisan test --parallel` - Parallel execution
