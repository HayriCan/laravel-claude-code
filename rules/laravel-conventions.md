# Laravel Conventions

Coding standards and naming conventions for Laravel applications.

## Naming Standards

| Type | Convention | Example |
|------|------------|---------|
| Model | Singular, PascalCase | `User`, `BlogPost` |
| Controller | Singular + Controller | `UserController`, `BlogPostController` |
| Table | Plural, snake_case | `users`, `blog_posts` |
| Column | snake_case | `created_at`, `user_id`, `is_active` |
| Foreign Key | singular_table_id | `user_id`, `post_id` |
| Pivot Table | Alphabetical, singular | `post_tag`, `role_user` |
| Method | camelCase | `getFullName()`, `isActive()` |
| Variable | camelCase | `$userCount`, `$isValid` |
| Route | kebab-case | `/blog-posts/{post}`, `/user-profile` |
| Route Name | dot notation | `posts.index`, `users.show` |
| Config | snake_case | `config('app.timezone')` |
| View | snake_case | `user_profile.blade.php` |

## File Size Limits

| File Type | Recommended | Maximum |
|-----------|-------------|---------|
| Controller | 200 lines | 400 lines |
| Model | 300 lines | 500 lines |
| Service | 200 lines | 400 lines |
| Action | 50 lines | 100 lines |
| View | 150 lines | 300 lines |
| Test | 100 lines | 200 lines |

## Method Length

| Type | Recommended | Maximum |
|------|-------------|---------|
| Controller method | 15 lines | 30 lines |
| Service method | 20 lines | 50 lines |
| Private helper | 10 lines | 20 lines |

## Controller Rules

### DO
- Use resourceful methods (index, create, store, show, edit, update, destroy)
- Use Form Requests for validation
- Use Policies for authorization
- Return Resources for APIs
- Keep controllers thin - delegate to services

### DON'T
- Put business logic in controllers
- Have more than 7 public methods
- Access request data without validation
- Use `$request->all()` for mass assignment

```php
// Good
class PostController extends Controller
{
    public function store(StorePostRequest $request, PostService $service)
    {
        $post = $service->create($request->validated());
        return new PostResource($post);
    }
}

// Bad
class PostController extends Controller
{
    public function store(Request $request)
    {
        $post = Post::create($request->all()); // No validation, mass assignment risk
        // 50 lines of business logic...
        return response()->json($post);
    }
}
```

## Model Rules

### DO
- Use `$fillable` for mass assignment protection
- Define all `$casts`
- Define all relationships with return types
- Use query scopes for reusable conditions
- Use accessors/mutators for data transformation

### DON'T
- Use `$guarded = []`
- Put HTTP logic in models
- Have fat models with business logic

```php
// Good
class Post extends Model
{
    protected $fillable = ['title', 'content', 'user_id'];

    protected $casts = [
        'published_at' => 'datetime',
        'metadata' => 'array',
    ];

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function scopePublished($query)
    {
        return $query->whereNotNull('published_at');
    }
}
```

## Directory Structure

```
app/
├── Actions/           # Single-purpose action classes
├── Http/
│   ├── Controllers/
│   ├── Middleware/
│   ├── Requests/      # Form Requests
│   └── Resources/     # API Resources
├── Models/
├── Policies/
├── Providers/
└── Services/          # Business logic services

database/
├── factories/
├── migrations/
└── seeders/

tests/
├── Feature/
└── Unit/
```

## Route Conventions

```php
// RESTful resource routes
Route::apiResource('posts', PostController::class);

// Generates:
// GET    /posts          posts.index
// POST   /posts          posts.store
// GET    /posts/{post}   posts.show
// PUT    /posts/{post}   posts.update
// DELETE /posts/{post}   posts.destroy

// Nested resources
Route::apiResource('posts.comments', CommentController::class)->shallow();

// Route model binding
Route::get('/posts/{post}', [PostController::class, 'show']);
// Controller receives Post model automatically
```

## Form Request Conventions

```php
class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Or policy check
    }

    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'content' => ['required', 'string'],
            'category_id' => ['required', 'exists:categories,id'],
        ];
    }
}
```
