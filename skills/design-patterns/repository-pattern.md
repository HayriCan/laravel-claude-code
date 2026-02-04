# Repository Pattern

Abstract database operations behind interfaces for better testability and flexibility.

## Structure

```
app/
├── Repositories/
│   ├── Contracts/
│   │   └── UserRepositoryInterface.php
│   └── Eloquent/
│       └── UserRepository.php
```

## Implementation

### Interface

```php
<?php

namespace App\Repositories\Contracts;

use App\Models\User;
use Illuminate\Pagination\LengthAwarePaginator;

interface UserRepositoryInterface
{
    public function find(int $id): ?User;

    public function findByEmail(string $email): ?User;

    public function create(array $data): User;

    public function update(User $user, array $data): User;

    public function delete(User $user): bool;

    public function paginate(int $perPage = 15): LengthAwarePaginator;

    public function findActive(): Collection;
}
```

### Eloquent Implementation

```php
<?php

namespace App\Repositories\Eloquent;

use App\Models\User;
use App\Repositories\Contracts\UserRepositoryInterface;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;

class UserRepository implements UserRepositoryInterface
{
    public function __construct(
        private User $model
    ) {}

    public function find(int $id): ?User
    {
        return $this->model->find($id);
    }

    public function findByEmail(string $email): ?User
    {
        return $this->model->where('email', $email)->first();
    }

    public function create(array $data): User
    {
        return $this->model->create($data);
    }

    public function update(User $user, array $data): User
    {
        $user->update($data);
        return $user->fresh();
    }

    public function delete(User $user): bool
    {
        return $user->delete();
    }

    public function paginate(int $perPage = 15): LengthAwarePaginator
    {
        return $this->model->paginate($perPage);
    }

    public function findActive(): Collection
    {
        return $this->model
            ->where('active', true)
            ->orderBy('name')
            ->get();
    }
}
```

### Service Provider Binding

```php
// App\Providers\RepositoryServiceProvider

public function register(): void
{
    $this->app->bind(
        UserRepositoryInterface::class,
        UserRepository::class
    );
}
```

### Usage in Service

```php
<?php

namespace App\Services;

use App\Repositories\Contracts\UserRepositoryInterface;

class UserService
{
    public function __construct(
        private UserRepositoryInterface $users
    ) {}

    public function findOrFail(int $id): User
    {
        $user = $this->users->find($id);

        if (!$user) {
            throw new UserNotFoundException();
        }

        return $user;
    }
}
```

## Testing with Fake Repository

```php
<?php

namespace Tests\Fakes;

use App\Repositories\Contracts\UserRepositoryInterface;
use Illuminate\Support\Collection;

class FakeUserRepository implements UserRepositoryInterface
{
    private Collection $users;

    public function __construct()
    {
        $this->users = collect();
    }

    public function find(int $id): ?User
    {
        return $this->users->firstWhere('id', $id);
    }

    public function create(array $data): User
    {
        $user = new User($data);
        $user->id = $this->users->count() + 1;
        $this->users->push($user);
        return $user;
    }

    // ... other methods
}
```

```php
it('finds user by id', function () {
    $repository = new FakeUserRepository();
    $user = $repository->create(['name' => 'John']);

    $service = new UserService($repository);

    expect($service->findOrFail($user->id))
        ->name->toBe('John');
});
```

## When to Use Repository

**Use Repository When:**
- Need to swap implementations (e.g., Eloquent to API)
- Complex queries that should be reusable
- Want to mock database in unit tests
- Multiple data sources

**Skip Repository When:**
- Simple CRUD with no complex queries
- Prototyping or small projects
- Using query scopes is sufficient
