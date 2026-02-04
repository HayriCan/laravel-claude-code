---
name: eloquent
description: Eloquent ORM mastery including relationships, eager loading, query scopes, and performance optimization
version: 1.0.0
---

# Eloquent Mastery

Complete guide to Laravel's Eloquent ORM for efficient database operations.

## When to Use

Activate this skill when:
- Working with database models
- Defining relationships
- Optimizing queries
- Preventing N+1 problems
- Handling large datasets

## Topics Covered

### Relationships (`relationships.md`)
All relationship types with proper definitions and usage patterns.

### Query Optimization (`query-optimization.md`)
Performance techniques including eager loading, chunking, and indexing.

## Quick Reference

### Relationship Types
| Type | Method | Inverse |
|------|--------|---------|
| One to One | `hasOne()` | `belongsTo()` |
| One to Many | `hasMany()` | `belongsTo()` |
| Many to Many | `belongsToMany()` | `belongsToMany()` |
| Has One Through | `hasOneThrough()` | - |
| Has Many Through | `hasManyThrough()` | - |
| Polymorphic | `morphTo()` | `morphMany()` |

### N+1 Prevention
```php
// Bad: N+1 queries
$posts = Post::all();
foreach ($posts as $post) {
    echo $post->author->name; // Query per post
}

// Good: Eager loading
$posts = Post::with('author')->get();
foreach ($posts as $post) {
    echo $post->author->name; // No additional queries
}
```

### Common Patterns
```php
// Select specific columns
User::select(['id', 'name', 'email'])->get();

// Use exists() instead of count()
if (User::where('email', $email)->exists()) { }

// Chunk large datasets
User::chunk(1000, fn ($users) => process($users));

// Cursor for memory efficiency
foreach (User::cursor() as $user) { }
```

## Model Template

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'content',
        'user_id',
        'published_at',
    ];

    protected $casts = [
        'published_at' => 'datetime',
        'metadata' => 'array',
    ];

    // Relationships
    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    // Scopes
    public function scopePublished($query)
    {
        return $query->whereNotNull('published_at')
            ->where('published_at', '<=', now());
    }

    public function scopeByAuthor($query, User $user)
    {
        return $query->where('user_id', $user->id);
    }
}
```
