# Eloquent Relationships

Comprehensive guide to defining and using Eloquent relationships.

## One to One

```php
// User has one Profile
class User extends Model
{
    public function profile(): HasOne
    {
        return $this->hasOne(Profile::class);
    }
}

// Profile belongs to User
class Profile extends Model
{
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}

// Usage
$user->profile;
$profile->user;
```

## One to Many

```php
// User has many Posts
class User extends Model
{
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}

// Post belongs to User
class Post extends Model
{
    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}

// Usage
$user->posts;
$post->author;
```

## Many to Many

```php
// User has many Roles
class User extends Model
{
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class)
            ->withTimestamps()
            ->withPivot('assigned_by');
    }
}

// Role has many Users
class Role extends Model
{
    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class);
    }
}

// Usage
$user->roles;
$user->roles()->attach($roleId);
$user->roles()->detach($roleId);
$user->roles()->sync([$roleId1, $roleId2]);
```

## Has Many Through

```php
// Country has many Posts through Users
class Country extends Model
{
    public function posts(): HasManyThrough
    {
        return $this->hasManyThrough(Post::class, User::class);
    }
}

// Usage
$country->posts;
```

## Polymorphic Relations

### One to Many Polymorphic

```php
// Comment can belong to Post or Video
class Comment extends Model
{
    public function commentable(): MorphTo
    {
        return $this->morphTo();
    }
}

class Post extends Model
{
    public function comments(): MorphMany
    {
        return $this->morphMany(Comment::class, 'commentable');
    }
}

class Video extends Model
{
    public function comments(): MorphMany
    {
        return $this->morphMany(Comment::class, 'commentable');
    }
}

// Migration
Schema::create('comments', function (Blueprint $table) {
    $table->id();
    $table->text('body');
    $table->morphs('commentable'); // commentable_type, commentable_id
    $table->timestamps();
});
```

### Many to Many Polymorphic

```php
// Tags can be attached to Posts and Videos
class Tag extends Model
{
    public function posts(): MorphToMany
    {
        return $this->morphedByMany(Post::class, 'taggable');
    }

    public function videos(): MorphToMany
    {
        return $this->morphedByMany(Video::class, 'taggable');
    }
}

class Post extends Model
{
    public function tags(): MorphToMany
    {
        return $this->morphToMany(Tag::class, 'taggable');
    }
}
```

## Eager Loading

```php
// Basic eager loading
$posts = Post::with('author')->get();

// Multiple relationships
$posts = Post::with(['author', 'comments'])->get();

// Nested eager loading
$posts = Post::with('comments.author')->get();

// Constrained eager loading
$posts = Post::with(['comments' => function ($query) {
    $query->where('approved', true)
          ->orderBy('created_at', 'desc');
}])->get();

// Eager load counts
$posts = Post::withCount('comments')->get();
// Access: $post->comments_count
```

## Relationship Queries

```php
// Filter by relationship existence
$usersWithPosts = User::has('posts')->get();
$usersWithManyPosts = User::has('posts', '>=', 5)->get();

// Filter by relationship condition
$users = User::whereHas('posts', function ($query) {
    $query->where('published', true);
})->get();

// Filter by missing relationship
$usersWithoutPosts = User::doesntHave('posts')->get();
```

## Best Practices

1. **Always define inverse relationships**
2. **Use return type hints** (`HasMany`, `BelongsTo`, etc.)
3. **Name relationships clearly** (`author` instead of `user` when contextual)
4. **Eager load to prevent N+1**
5. **Use `withDefault()` for optional relationships**

```php
public function author(): BelongsTo
{
    return $this->belongsTo(User::class)->withDefault([
        'name' => 'Anonymous',
    ]);
}
```
