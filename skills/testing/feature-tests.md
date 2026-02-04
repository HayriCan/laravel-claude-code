# Feature Tests

HTTP testing patterns for Laravel controllers and APIs.

## Basic HTTP Tests

```php
use function Pest\Laravel\{get, post, put, delete, getJson, postJson};

it('shows the homepage', function () {
    get('/')->assertOk();
});

it('returns users list', function () {
    User::factory()->count(3)->create();

    getJson('/api/users')
        ->assertOk()
        ->assertJsonCount(3, 'data');
});
```

## CRUD Testing Pattern

```php
describe('PostController', function () {
    describe('index', function () {
        it('returns paginated posts', function () {
            Post::factory()->count(20)->create();

            getJson('/api/posts')
                ->assertOk()
                ->assertJsonStructure([
                    'data' => [['id', 'title', 'content']],
                    'meta' => ['current_page', 'per_page', 'total'],
                ]);
        });
    });

    describe('store', function () {
        it('creates post with valid data', function () {
            $user = User::factory()->create();

            actingAs($user)
                ->postJson('/api/posts', [
                    'title' => 'Test Post',
                    'content' => 'Test content here',
                ])
                ->assertCreated()
                ->assertJson([
                    'data' => ['title' => 'Test Post'],
                ]);

            $this->assertDatabaseHas('posts', ['title' => 'Test Post']);
        });
    });

    describe('show', function () {
        it('returns single post', function () {
            $post = Post::factory()->create();

            getJson("/api/posts/{$post->id}")
                ->assertOk()
                ->assertJson([
                    'data' => ['id' => $post->id],
                ]);
        });

        it('returns 404 for missing post', function () {
            getJson('/api/posts/99999')
                ->assertNotFound();
        });
    });

    describe('update', function () {
        it('updates post', function () {
            $post = Post::factory()->create();
            $user = $post->author;

            actingAs($user)
                ->putJson("/api/posts/{$post->id}", [
                    'title' => 'Updated Title',
                ])
                ->assertOk();

            expect($post->fresh()->title)->toBe('Updated Title');
        });
    });

    describe('destroy', function () {
        it('deletes post', function () {
            $post = Post::factory()->create();
            $user = $post->author;

            actingAs($user)
                ->deleteJson("/api/posts/{$post->id}")
                ->assertNoContent();

            $this->assertDatabaseMissing('posts', ['id' => $post->id]);
        });
    });
});
```

## Authentication Testing

```php
describe('authentication', function () {
    it('requires authentication', function () {
        getJson('/api/profile')
            ->assertUnauthorized();
    });

    it('returns user profile when authenticated', function () {
        $user = User::factory()->create();

        actingAs($user)
            ->getJson('/api/profile')
            ->assertOk()
            ->assertJson([
                'data' => ['id' => $user->id],
            ]);
    });

    it('authenticates with sanctum token', function () {
        $user = User::factory()->create();
        $token = $user->createToken('test')->plainTextToken;

        getJson('/api/profile', [
            'Authorization' => "Bearer {$token}",
        ])->assertOk();
    });
});
```

## Authorization Testing

```php
describe('authorization', function () {
    it('denies access to other users post', function () {
        $post = Post::factory()->create();
        $otherUser = User::factory()->create();

        actingAs($otherUser)
            ->putJson("/api/posts/{$post->id}", ['title' => 'Hacked'])
            ->assertForbidden();
    });

    it('allows owner to update post', function () {
        $post = Post::factory()->create();

        actingAs($post->author)
            ->putJson("/api/posts/{$post->id}", ['title' => 'Updated'])
            ->assertOk();
    });

    it('allows admin to update any post', function () {
        $post = Post::factory()->create();
        $admin = User::factory()->admin()->create();

        actingAs($admin)
            ->putJson("/api/posts/{$post->id}", ['title' => 'Admin Edit'])
            ->assertOk();
    });
});
```

## Validation Testing

```php
describe('validation', function () {
    beforeEach(function () {
        $this->user = User::factory()->create();
    });

    it('requires title', function () {
        actingAs($this->user)
            ->postJson('/api/posts', ['content' => 'Some content'])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['title']);
    });

    it('requires title to be string', function () {
        actingAs($this->user)
            ->postJson('/api/posts', ['title' => 123])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['title']);
    });

    it('validates multiple fields', function () {
        actingAs($this->user)
            ->postJson('/api/posts', [])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['title', 'content']);
    });

    it('validates unique email', function () {
        User::factory()->create(['email' => 'taken@example.com']);

        postJson('/api/register', [
            'name' => 'John',
            'email' => 'taken@example.com',
            'password' => 'password',
        ])->assertUnprocessable()
          ->assertJsonValidationErrors(['email']);
    });
});
```

## File Upload Testing

```php
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

it('uploads avatar', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $file = UploadedFile::fake()->image('avatar.jpg');

    actingAs($user)
        ->postJson('/api/profile/avatar', ['avatar' => $file])
        ->assertOk();

    Storage::disk('public')->assertExists('avatars/' . $file->hashName());
});

it('rejects non-image files', function () {
    $user = User::factory()->create();
    $file = UploadedFile::fake()->create('document.pdf');

    actingAs($user)
        ->postJson('/api/profile/avatar', ['avatar' => $file])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['avatar']);
});
```

## Database Testing

```php
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

it('creates user in database', function () {
    postJson('/api/register', [
        'name' => 'John',
        'email' => 'john@example.com',
        'password' => 'password',
    ])->assertCreated();

    $this->assertDatabaseHas('users', [
        'name' => 'John',
        'email' => 'john@example.com',
    ]);
});

it('soft deletes user', function () {
    $user = User::factory()->create();

    actingAs($user)
        ->deleteJson('/api/profile')
        ->assertNoContent();

    $this->assertSoftDeleted('users', ['id' => $user->id]);
});
```
