---
name: laravel-brainstorming
description: Use before any creative work - creating features, building components, adding functionality - explores user intent, requirements and Laravel architecture decisions before implementation
---

# Laravel Brainstorming

## Overview

Help turn ideas into fully formed Laravel designs through natural collaborative dialogue.

**Core principle:** Understand requirements completely before writing any code.

**Announce at start:** "I'm using the laravel-brainstorming skill to design this feature."

## The Process

### Phase 1: Understanding the Idea

**Ask questions one at a time:**
- What problem are you solving?
- Who are the users?
- What are the success criteria?

**Prefer multiple choice when possible:**
```
What type of endpoint is this?
1. REST API (JSON responses)
2. Web (Blade views)
3. Both (API + Web)
```

### Phase 2: Exploring Approaches

**Propose 2-3 Laravel approaches with trade-offs:**

```
For user authentication, I see three approaches:

1. **Laravel Breeze** (Recommended)
   - Minimal scaffolding
   - Easy to customize
   - Good for APIs

2. **Laravel Jetstream**
   - Full-featured (teams, 2FA)
   - More complex
   - Livewire or Inertia

3. **Custom implementation**
   - Full control
   - More work
   - No external dependencies

I recommend Breeze because you mentioned simplicity is important.
Which approach fits your needs?
```

### Phase 3: Laravel Architecture Decisions

**Questions to clarify:**

| Decision | Options |
|----------|---------|
| **Data layer** | Eloquent direct vs Repository pattern |
| **Business logic** | Controller vs Service class vs Action class |
| **Validation** | Form Request vs inline validation |
| **Authorization** | Policy vs Gate vs middleware |
| **API format** | JSON Resource vs direct response |

### Phase 4: Presenting the Design

**Break into sections (200-300 words each):**

1. **Database Design**
   - Tables and relationships
   - Migrations needed

2. **Models**
   - Eloquent models
   - Relationships
   - Accessors/mutators

3. **API/Routes**
   - Endpoints
   - HTTP methods
   - Route groups

4. **Controllers & Services**
   - Responsibility split
   - Method signatures

5. **Testing Strategy**
   - Feature tests
   - Edge cases to cover

**After each section:** "Does this look right so far?"

### Phase 5: Documentation

Save the validated design:
```
docs/plans/YYYY-MM-DD-<feature-name>-design.md
```

## Laravel-Specific Questions

### For CRUD Features
- Soft deletes needed?
- Pagination style (cursor/offset)?
- Search/filter requirements?
- Bulk operations needed?

### For Authentication Features
- Session vs token (Sanctum)?
- Social login providers?
- Multi-factor authentication?
- Password reset flow?

### For File Handling
- Storage disk (local/S3)?
- Allowed file types?
- Size limits?
- Image processing needed?

### For Background Jobs
- Queue driver (sync/redis/database)?
- Retry strategy?
- Failure handling?
- Rate limiting?

## Key Principles

- **One question at a time** - Don't overwhelm
- **Multiple choice preferred** - Easier to answer
- **YAGNI ruthlessly** - Remove unnecessary features
- **Laravel conventions** - Follow framework patterns
- **Incremental validation** - Validate each section

## After the Design

**Documentation:**
- Write design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Commit the design document

**Implementation (if continuing):**
- Ask: "Ready to create the implementation plan?"
- Use **laravel-planning** skill to create detailed tasks

## Design Template

```markdown
# [Feature Name] Design

## Overview
[One paragraph describing the feature]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Database Schema
[Tables, columns, relationships]

## API Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/... | Create... |

## Components
- Model: `App\Models\...`
- Controller: `App\Http\Controllers\...`
- Service: `App\Services\...`
- Request: `App\Http\Requests\...`

## Testing Approach
- Feature tests for happy path
- Validation tests
- Authorization tests

## Open Questions
[Any remaining decisions]
```

## Red Flags

**Never:**
- Start coding without design approval
- Skip architecture questions
- Make assumptions about requirements
- Design more than requested (YAGNI)

**Always:**
- Ask one question at a time
- Validate design incrementally
- Document decisions
- Get explicit approval before implementation
