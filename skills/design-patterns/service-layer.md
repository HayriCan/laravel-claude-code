# Service Layer Pattern

Encapsulate business logic in dedicated service classes to keep controllers thin and logic reusable.

## Structure

```
app/
└── Services/
    ├── UserService.php
    ├── OrderService.php
    └── PaymentService.php
```

## Implementation

### Basic Service Class

```php
<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use App\Mail\WelcomeEmail;
use App\Events\UserRegistered;

class UserService
{
    public function register(array $data): User
    {
        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
        ]);

        $user->assignRole('member');

        Mail::to($user)->send(new WelcomeEmail($user));

        event(new UserRegistered($user));

        return $user;
    }

    public function updateProfile(User $user, array $data): User
    {
        $user->update($data);

        if (isset($data['avatar'])) {
            $this->updateAvatar($user, $data['avatar']);
        }

        return $user->fresh();
    }

    private function updateAvatar(User $user, $avatar): void
    {
        $path = $avatar->store('avatars', 'public');
        $user->update(['avatar' => $path]);
    }
}
```

### Controller Usage

```php
<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreUserRequest;
use App\Http\Resources\UserResource;
use App\Services\UserService;

class UserController extends Controller
{
    public function __construct(
        private UserService $userService
    ) {}

    public function store(StoreUserRequest $request): UserResource
    {
        $user = $this->userService->register($request->validated());

        return new UserResource($user);
    }
}
```

## Service with Dependencies

```php
<?php

namespace App\Services;

use App\Repositories\UserRepository;
use App\Services\NotificationService;
use Illuminate\Contracts\Events\Dispatcher;

class UserService
{
    public function __construct(
        private UserRepository $users,
        private NotificationService $notifications,
        private Dispatcher $events
    ) {}

    public function register(array $data): User
    {
        $user = $this->users->create($data);

        $this->notifications->sendWelcome($user);

        $this->events->dispatch(new UserRegistered($user));

        return $user;
    }
}
```

## Testing Services

```php
it('registers user with hashed password', function () {
    $service = app(UserService::class);

    $user = $service->register([
        'name' => 'John Doe',
        'email' => 'john@example.com',
        'password' => 'password',
    ]);

    expect($user)
        ->toBeInstanceOf(User::class)
        ->name->toBe('John Doe')
        ->password->not->toBe('password');

    expect(Hash::check('password', $user->password))->toBeTrue();
});

it('sends welcome email on registration', function () {
    Mail::fake();

    $service = app(UserService::class);
    $user = $service->register([...]);

    Mail::assertSent(WelcomeEmail::class, fn ($mail) =>
        $mail->hasTo($user->email)
    );
});
```

## Best Practices

1. **Single Responsibility**: Each service handles one domain
2. **Inject Dependencies**: Use constructor injection
3. **Return Types**: Always specify return types
4. **No HTTP Concerns**: Services shouldn't know about requests/responses
5. **Testable**: Design for easy unit testing
