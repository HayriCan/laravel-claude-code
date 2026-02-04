# Pest PHP Fundamentals

Modern, elegant testing syntax for Laravel applications.

## Basic Syntax

### Simple Tests
```php
it('adds two numbers', function () {
    expect(1 + 1)->toBe(2);
});

test('user can be created', function () {
    $user = User::factory()->create();
    expect($user)->toBeInstanceOf(User::class);
});
```

### Higher-Order Tests
```php
it('has a name')
    ->expect(fn () => User::factory()->create())
    ->name->not->toBeEmpty();

it('requires authentication')
    ->getJson('/api/profile')
    ->assertUnauthorized();
```

## Expectations

### Basic Expectations
```php
expect($value)->toBe($expected);        // Strict equality
expect($value)->toEqual($expected);     // Loose equality
expect($value)->toBeTrue();
expect($value)->toBeFalse();
expect($value)->toBeNull();
expect($value)->toBeEmpty();
expect($value)->toBeArray();
expect($value)->toBeString();
expect($value)->toBeInt();
```

### Chained Expectations
```php
expect($user)
    ->toBeInstanceOf(User::class)
    ->name->toBe('John')
    ->email->toContain('@')
    ->and($user->posts)
    ->toHaveCount(3);
```

### Collection Expectations
```php
expect($users)
    ->toBeCollection()
    ->toHaveCount(5)
    ->each->toBeInstanceOf(User::class);
```

### Exception Expectations
```php
it('throws exception for invalid email', function () {
    $this->service->validate('invalid');
})->throws(InvalidEmailException::class);

it('throws with message', function () {
    throw new Exception('Something went wrong');
})->throws(Exception::class, 'Something went wrong');
```

## Datasets

### Inline Datasets
```php
it('validates email', function (string $email, bool $valid) {
    expect(filter_var($email, FILTER_VALIDATE_EMAIL))
        ->toBe($valid ? $email : false);
})->with([
    ['valid@email.com', true],
    ['invalid', false],
    ['another@valid.org', true],
]);
```

### Named Datasets
```php
it('calculates discount', function (int $quantity, float $expected) {
    expect(calculateDiscount($quantity))->toBe($expected);
})->with([
    'no discount' => [1, 0.0],
    'small discount' => [5, 5.0],
    'big discount' => [10, 10.0],
]);
```

### Dataset Files
```php
// tests/Datasets/Emails.php
dataset('valid_emails', [
    'simple' => ['test@example.com'],
    'subdomain' => ['test@sub.example.com'],
]);

// In test file
it('accepts valid emails', function (string $email) {
    expect(isValidEmail($email))->toBeTrue();
})->with('valid_emails');
```

## Grouping & Hooks

### Describe Blocks
```php
describe('User Registration', function () {
    beforeEach(function () {
        $this->data = [
            'name' => 'John',
            'email' => 'john@example.com',
            'password' => 'password123',
        ];
    });

    it('creates user with valid data', function () {
        $this->postJson('/api/register', $this->data)
            ->assertCreated();
    });

    it('requires email', function () {
        unset($this->data['email']);

        $this->postJson('/api/register', $this->data)
            ->assertUnprocessable()
            ->assertJsonValidationErrors('email');
    });
});
```

### Lifecycle Hooks
```php
beforeAll(function () {
    // Runs once before all tests in file
});

beforeEach(function () {
    // Runs before each test
    $this->user = User::factory()->create();
});

afterEach(function () {
    // Runs after each test
});

afterAll(function () {
    // Runs once after all tests in file
});
```

## Architecture Testing

```php
arch('controllers')
    ->expect('App\Http\Controllers')
    ->toExtend('App\Http\Controllers\Controller')
    ->toHaveSuffix('Controller');

arch('models')
    ->expect('App\Models')
    ->toExtend('Illuminate\Database\Eloquent\Model')
    ->toHaveMethod('factory');

arch('no debugging')
    ->expect(['dd', 'dump', 'ray', 'var_dump'])
    ->not->toBeUsed();

arch('services are final')
    ->expect('App\Services')
    ->toBeFinal();
```

## Skipping & Focusing

```php
it('is skipped')->skip();

it('is skipped with reason')->skip('Not implemented yet');

it('only runs this one')->only();

it('runs on specific condition', function () {
    // ...
})->skipOnWindows();
```
