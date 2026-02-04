---
name: laravel-planning
description: Use when you have a design or requirements for a Laravel feature, before touching code - creates detailed implementation plans with TDD steps
---

# Laravel Implementation Planning

## Overview

Write comprehensive implementation plans assuming the engineer has zero Laravel context. Document everything: files, code, testing, verification. Bite-sized tasks. DRY. YAGNI. TDD.

**Announce at start:** "I'm using the laravel-planning skill to create the implementation plan."

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Plan Document Header

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** Use laravel-executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about Laravel approach]

**Tech Stack:** Laravel, Pest PHP, [other relevant packages]

---
```

## Task Structure

Each task is one focused unit of work (2-5 minutes):

```markdown
### Task N: [Component Name]

**Files:**
- Create: `database/migrations/YYYY_MM_DD_create_posts_table.php`
- Create: `app/Models/Post.php`
- Create: `tests/Feature/PostTest.php`

**Step 1: Write the failing test**

```php
// tests/Feature/PostTest.php
it('creates a post', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/posts', ['title' => 'Test']);

    $response->assertCreated();
    $this->assertDatabaseHas('posts', ['title' => 'Test']);
});
```

**Step 2: Run test to verify it fails**

```bash
php artisan test --filter="creates a post"
```
Expected: FAIL - Route [api/posts] not defined

**Step 3: Create migration**

```php
// database/migrations/YYYY_MM_DD_create_posts_table.php
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('title');
    $table->timestamps();
});
```

**Step 4: Create model**

```php
// app/Models/Post.php
class Post extends Model
{
    protected $fillable = ['user_id', 'title'];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

**Step 5: Create route and controller**

[Route and controller code]

**Step 6: Run test to verify it passes**

```bash
php artisan test --filter="creates a post"
```
Expected: PASS

**Step 7: Commit**

```bash
git add -A && git commit -m "feat(posts): add post creation endpoint"
```
```

## Laravel Task Order

Follow this order for typical features:

1. **Migration** - Database schema first
2. **Model** - Eloquent model with relationships
3. **Tests** - Feature tests (TDD)
4. **Controller** - HTTP layer
5. **Form Request** - Validation
6. **Policy** - Authorization
7. **Routes** - API/web routes
8. **Service** - Business logic (if needed)

## Quick Reference

### Common Laravel Patterns

| Component | Location | Naming |
|-----------|----------|--------|
| Migration | `database/migrations/` | `YYYY_MM_DD_create_posts_table.php` |
| Model | `app/Models/` | `Post.php` |
| Controller | `app/Http/Controllers/` | `PostController.php` |
| Request | `app/Http/Requests/` | `StorePostRequest.php` |
| Policy | `app/Policies/` | `PostPolicy.php` |
| Service | `app/Services/` | `PostService.php` |
| Test | `tests/Feature/` | `PostTest.php` |

### Artisan Commands for Tasks

```bash
php artisan make:model Post -mf      # Model + migration + factory
php artisan make:controller PostController --api  # API controller
php artisan make:request StorePostRequest  # Form request
php artisan make:policy PostPolicy --model=Post  # Policy
php artisan make:test PostTest         # Feature test
```

## Execution Handoff

After saving the plan:

```markdown
Plan complete and saved to `docs/plans/<filename>.md`.

Two execution options:

1. **Same session** - I execute tasks with verification between each
2. **New session** - Open new terminal, use /execute-plan

Which approach?
```

**If same session chosen:**
- Use **laravel-executing-plans** skill
- Execute in batches of 3 tasks
- Verify between batches

## Key Principles

- **Exact file paths** - No ambiguity
- **Complete code** - Not "add validation"
- **Exact commands** - With expected output
- **TDD steps** - RED-GREEN-REFACTOR explicit
- **Laravel conventions** - Follow framework patterns
- **Frequent commits** - After each logical unit

## Plan Template

```markdown
# [Feature] Implementation Plan

> **For Claude:** Use laravel-executing-plans to implement.

**Goal:** [What this builds]
**Architecture:** [Laravel approach]
**Tech Stack:** Laravel, Pest PHP

---

### Task 1: Database Setup

**Files:**
- Create: `database/migrations/...`
- Create: `app/Models/...`

**Steps:**
[TDD steps with code]

---

### Task 2: API Endpoints

**Files:**
- Create: `app/Http/Controllers/...`
- Create: `routes/api.php` (modify)

**Steps:**
[TDD steps with code]

---

### Task N: [Component]

...

---

## Verification Checklist

- [ ] All tests pass: `php artisan test`
- [ ] Code style: `./vendor/bin/pint --test`
- [ ] Static analysis: `./vendor/bin/phpstan analyse`
```

## Red Flags

**Never:**
- Vague file paths
- Incomplete code snippets
- Skip TDD steps
- Large monolithic tasks
- Missing verification commands

**Always:**
- One task = one commit
- Include test commands
- Show expected output
- Follow Laravel conventions
