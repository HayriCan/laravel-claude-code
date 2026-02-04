# Query Optimization

Techniques for optimizing Eloquent queries and database performance.

## N+1 Problem Detection

### The Problem
```php
// This executes N+1 queries
$posts = Post::all(); // 1 query
foreach ($posts as $post) {
    echo $post->author->name; // N queries
}
```

### The Solution
```php
// Eager load - only 2 queries
$posts = Post::with('author')->get();
foreach ($posts as $post) {
    echo $post->author->name;
}
```

## Eager Loading Patterns

```php
// Multiple relationships
Post::with(['author', 'comments', 'tags'])->get();

// Nested relationships
Post::with('comments.author')->get();

// Constrained eager loading
Post::with(['comments' => fn($q) => $q->where('approved', true)])->get();

// Select specific columns
Post::with('author:id,name')->get();

// Load counts without loading records
Post::withCount('comments')->get();
// Access: $post->comments_count

// Conditional counts
Post::withCount(['comments as approved_count' => fn($q) =>
    $q->where('approved', true)
])->get();
```

## Select Optimization

```php
// Bad: Select all columns
$users = User::all();

// Good: Select only needed columns
$users = User::select(['id', 'name', 'email'])->get();

// With relationships
$posts = Post::select(['id', 'title', 'user_id'])
    ->with('author:id,name')
    ->get();
```

## Existence Checks

```php
// Bad: Loads all records to count
if (User::where('email', $email)->count() > 0) { }

// Good: Uses EXISTS query
if (User::where('email', $email)->exists()) { }

// For relationships
if ($user->posts()->exists()) { }
```

## Large Dataset Handling

### Chunking
```php
// Process in chunks to limit memory
User::chunk(1000, function ($users) {
    foreach ($users as $user) {
        // Process user
    }
});

// Chunk by ID for stability during updates
User::chunkById(1000, function ($users) {
    foreach ($users as $user) {
        $user->update(['processed' => true]);
    }
});
```

### Lazy Collections
```php
// Memory efficient iteration
User::lazy()->each(function ($user) {
    // Process user
});
```

### Cursors
```php
// Single record in memory at a time
foreach (User::cursor() as $user) {
    // Process user
}
```

## Index Recommendations

### Columns to Index
```php
// Foreign keys
$table->foreignId('user_id')->constrained();

// Frequently filtered columns
$table->index('status');
$table->index('email');

// Composite indexes for multi-column queries
$table->index(['status', 'created_at']);
$table->index(['user_id', 'published_at']);

// Unique constraints (automatically indexed)
$table->unique('email');
```

### Query Analysis
```php
// See the raw SQL
User::where('active', true)->toSql();

// With bindings
User::where('active', true)->toRawSql();

// Explain query
User::where('active', true)->explain();
```

## Aggregation Optimization

```php
// Bad: Load all records then count
$total = Post::all()->count();

// Good: Database-level count
$total = Post::count();

// Multiple aggregations in one query
$stats = Post::selectRaw('
    COUNT(*) as total,
    SUM(views) as total_views,
    AVG(views) as avg_views
')->first();
```

## Avoiding Common Pitfalls

```php
// Bad: Filtering after loading
$activeUsers = User::all()->where('active', true);

// Good: Filter at database level
$activeUsers = User::where('active', true)->get();

// Bad: Loading relations in loop
foreach ($posts as $post) {
    $post->load('author'); // N queries
}

// Good: Lazy eager load collection
$posts->load('author'); // 1 query

// Bad: Unnecessary hydration
$names = User::all()->pluck('name');

// Good: Query builder for simple data
$names = User::pluck('name');
```

## Caching Strategies

```php
// Cache expensive queries
$users = Cache::remember('active-users', 3600, function () {
    return User::where('active', true)
        ->with('roles')
        ->get();
});

// Cache counts
$count = Cache::remember('users-count', 3600, function () {
    return User::count();
});
```
