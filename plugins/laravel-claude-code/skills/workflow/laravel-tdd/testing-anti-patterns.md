# Laravel Testing Anti-Patterns

## Mock Abuse

### Bad: Testing Mock Instead of Code
```php
// Tests that the mock works, not your code
it('sends notification', function () {
    $mock = Mockery::mock(NotificationService::class);
    $mock->shouldReceive('send')->once()->andReturn(true);

    $this->app->instance(NotificationService::class, $mock);

    $service = app(UserService::class);
    $service->notify($user);

    // What did we prove? The mock returns true.
});
```

### Good: Test Real Behavior
```php
it('sends notification to user email', function () {
    Notification::fake();

    $user = User::factory()->create();

    $service = app(UserService::class);
    $service->notify($user);

    Notification::assertSentTo($user, WelcomeNotification::class);
});
```

## N+1 in Tests

### Bad: Creating Models One by One
```php
it('lists all posts', function () {
    // Creates 10 separate queries
    for ($i = 0; $i < 10; $i++) {
        Post::factory()->create();
    }
});
```

### Good: Use Factory Count
```php
it('lists all posts', function () {
    Post::factory()->count(10)->create();

    $response = $this->getJson('/api/posts');

    $response->assertOk()->assertJsonCount(10, 'data');
});
```

## Testing Implementation Not Behavior

### Bad: Testing Internal State
```php
it('sets processed flag', function () {
    $order = Order::factory()->create();

    $service = app(OrderService::class);
    $service->process($order);

    // Testing implementation detail
    expect($order->processed_at)->not->toBeNull();
    expect($order->processor_id)->toBe(1);
});
```

### Good: Test Observable Behavior
```php
it('allows shipping after processing', function () {
    $order = Order::factory()->create();

    $service = app(OrderService::class);
    $service->process($order);

    // Test what matters to the user
    expect($order->canShip())->toBeTrue();
});
```

## Fragile Assertions

### Bad: Exact JSON Match
```php
it('returns user', function () {
    $user = User::factory()->create();

    $response = $this->getJson("/api/users/{$user->id}");

    // Breaks if ANY field changes
    $response->assertExactJson([
        'id' => $user->id,
        'name' => $user->name,
        'email' => $user->email,
        'created_at' => $user->created_at->toISOString(),
        'updated_at' => $user->updated_at->toISOString(),
    ]);
});
```

### Good: Assert Structure and Key Fields
```php
it('returns user with expected fields', function () {
    $user = User::factory()->create(['name' => 'John']);

    $response = $this->getJson("/api/users/{$user->id}");

    $response->assertOk()
        ->assertJsonStructure(['id', 'name', 'email'])
        ->assertJsonPath('name', 'John');
});
```

## Missing Edge Cases

### Bad: Only Happy Path
```php
it('creates order', function () {
    $user = User::factory()->create();
    $product = Product::factory()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/orders', ['product_id' => $product->id]);

    $response->assertCreated();
});
```

### Good: Test Boundaries
```php
it('creates order', function () { /* ... */ });

it('rejects order for out-of-stock product', function () {
    $product = Product::factory()->outOfStock()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/orders', ['product_id' => $product->id]);

    $response->assertUnprocessable()
        ->assertJsonValidationErrors(['product_id']);
});

it('rejects order without authentication', function () {
    $response = $this->postJson('/api/orders', ['product_id' => 1]);

    $response->assertUnauthorized();
});

it('rejects order for non-existent product', function () {
    $response = $this->actingAs($user)
        ->postJson('/api/orders', ['product_id' => 99999]);

    $response->assertNotFound();
});
```

## Test Database Pollution

### Bad: Not Using RefreshDatabase
```php
// Tests affect each other
it('counts users', function () {
    User::factory()->count(5)->create();
    expect(User::count())->toBe(5);
});

it('also counts users', function () {
    // Might be 5 or 10 depending on run order
    User::factory()->count(5)->create();
    expect(User::count())->toBe(5); // FAILS
});
```

### Good: Use RefreshDatabase
```php
uses(RefreshDatabase::class);

it('counts users', function () {
    User::factory()->count(5)->create();
    expect(User::count())->toBe(5); // Always passes
});
```

## Summary

| Anti-Pattern | Fix |
|--------------|-----|
| Testing mocks | Use Laravel fakes (Notification::fake, etc.) |
| N+1 in setup | Use factory count |
| Testing implementation | Test observable behavior |
| Exact JSON match | Assert structure + key fields |
| Only happy path | Test validation, auth, edge cases |
| Database pollution | Use RefreshDatabase trait |
