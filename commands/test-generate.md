---
description: Generate Pest PHP tests for a class, feature, or API endpoint
argument-hint: <target> [--type=feature|unit|api]
---

# Test Generation

Generate comprehensive Pest PHP tests for your Laravel code.

## Usage

```
/test-generate App\Services\UserService           # Generate unit tests
/test-generate App\Http\Controllers\PostController # Generate feature tests
/test-generate App\Models\User                     # Generate model tests
/test-generate /api/posts --type=api              # Generate API tests
```

## Test Types

### Feature Tests (default for controllers)
- HTTP request/response testing
- Authentication scenarios
- Validation testing
- Authorization testing

### Unit Tests (default for services/classes)
- Method behavior testing
- Edge cases
- Exception handling
- Return value verification

### API Tests
- Endpoint response structure
- Status codes
- Pagination
- Error responses

## Generated Test Structure

```php
describe('ClassName', function () {
    describe('methodName', function () {
        it('does something specific', function () {
            // Arrange
            // Act
            // Assert
        });
    });
});
```

## Coverage Goals

- Happy path scenarios
- Validation failures
- Authorization checks
- Edge cases
- Error handling

## Options

- `--type=feature|unit|api`: Force specific test type
- Target can be a class name, file path, or API route

Launch the `pest-expert` agent to generate tests for: $ARGUMENTS
