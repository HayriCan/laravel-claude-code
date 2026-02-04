---
description: Generate complete feature with model, migration, service, controller, requests, and tests
argument-hint: <feature-name> [--type=api|web|both]
---

# Feature Generation

Scaffold a complete Laravel feature with all necessary layers.

## Usage

```
/make-feature Post                    # Create Post feature (both API and web)
/make-feature BlogPost --type=api     # API-only feature
/make-feature UserProfile --type=web  # Web-only feature
```

## Generated Files

### Model Layer
- `app/Models/{Name}.php` - Model with relationships, casts, fillable
- `database/migrations/create_{names}_table.php` - Migration
- `database/factories/{Name}Factory.php` - Factory for testing

### Service Layer
- `app/Services/{Name}Service.php` - Business logic

### HTTP Layer
- `app/Http/Controllers/{Name}Controller.php` - Controller
- `app/Http/Requests/Store{Name}Request.php` - Create validation
- `app/Http/Requests/Update{Name}Request.php` - Update validation
- `app/Http/Resources/{Name}Resource.php` - API resource (if API)
- `app/Policies/{Name}Policy.php` - Authorization policy

### Testing
- `tests/Feature/{Name}Test.php` - Feature tests

### Routes
- Suggests route registration for `routes/api.php` or `routes/web.php`

## Feature Structure

```
app/
├── Models/
│   └── {Name}.php
├── Services/
│   └── {Name}Service.php
├── Http/
│   ├── Controllers/
│   │   └── {Name}Controller.php
│   ├── Requests/
│   │   ├── Store{Name}Request.php
│   │   └── Update{Name}Request.php
│   └── Resources/
│       └── {Name}Resource.php
├── Policies/
│   └── {Name}Policy.php
database/
├── migrations/
│   └── create_{names}_table.php
├── factories/
│   └── {Name}Factory.php
tests/
└── Feature/
    └── {Name}Test.php
```

## Conventions

- Follows Laravel naming conventions
- Detects existing project patterns
- Uses Form Requests for validation
- Implements authorization via Policy
- Generates comprehensive tests

Create feature: $ARGUMENTS
