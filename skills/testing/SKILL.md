---
name: testing
description: Laravel testing with Pest PHP including feature tests, unit tests, and testing best practices
version: 1.0.0
---

# Laravel Testing

Guide for testing Laravel applications with Pest PHP.

## When to Use

Activate this skill when:
- Writing new tests
- Following TDD workflow
- Testing APIs
- Database testing
- Mocking dependencies

## Topics Covered

### Pest Fundamentals (`pest-fundamentals.md`)
Pest PHP syntax, expectations, datasets, and higher-order tests.

### Feature Tests (`feature-tests.md`)
HTTP testing patterns for controllers and APIs.

## Quick Reference

### Test Structure (AAA Pattern)
```php
it('creates a user', function () {
    // Arrange
    $data = ['name' => 'John', 'email' => 'john@example.com'];

    // Act
    $response = $this->postJson('/api/users', $data);

    // Assert
    $response->assertCreated();
    $this->assertDatabaseHas('users', $data);
});
```

### Common Assertions
```php
// HTTP assertions
$response->assertOk();           // 200
$response->assertCreated();      // 201
$response->assertNoContent();    // 204
$response->assertUnauthorized(); // 401
$response->assertForbidden();    // 403
$response->assertNotFound();     // 404
$response->assertUnprocessable(); // 422

// JSON assertions
$response->assertJson(['key' => 'value']);
$response->assertJsonCount(3, 'data');
$response->assertJsonStructure(['data' => ['id', 'name']]);

// Database assertions
$this->assertDatabaseHas('users', ['email' => 'john@example.com']);
$this->assertDatabaseMissing('users', ['email' => 'deleted@example.com']);
$this->assertDatabaseCount('users', 5);
```

### Pest Expectations
```php
expect($user)
    ->toBeInstanceOf(User::class)
    ->name->toBe('John')
    ->email->toContain('@')
    ->roles->toHaveCount(2);
```

## Testing Checklist

### Every Feature Should Test
- [ ] Happy path (success case)
- [ ] Validation failures
- [ ] Authentication (401)
- [ ] Authorization (403)
- [ ] Not found (404)
- [ ] Edge cases

### Test File Naming
```
tests/
├── Feature/
│   ├── Auth/
│   │   └── LoginTest.php
│   ├── Api/
│   │   └── PostControllerTest.php
│   └── Web/
│       └── DashboardTest.php
└── Unit/
    ├── Services/
    │   └── UserServiceTest.php
    └── Models/
        └── UserTest.php
```
