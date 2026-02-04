# Laravel Claude Code Marketplace

> Claude Code plugin marketplace for Laravel development with code review, Eloquent optimization, security auditing, Pest testing, and **Superpowers-style workflow** support.

## Installation

```bash
# Add marketplace
claude /marketplace add HayriCan/laravel-claude-code

# Install plugin
claude /plugin install laravel-claude-code@laravel-claude-code
```

## Features

- **5 Specialized Agents**: laravel-reviewer, eloquent-expert, security-auditor, pest-expert, spec-reviewer
- **10 Slash Commands**: Full development workflow from brainstorming to execution
- **4 Skill Categories**: design-patterns, eloquent, testing, workflow
- **Laravel Best Practices**: Conventions and security rules built-in
- **TDD Workflow**: RED-GREEN-REFACTOR with Pest PHP
- **Plan-Execute Pattern**: Structured implementation with verification checkpoints

## Quick Start

### Workflow Commands

```bash
/brainstorm                              # Design a new feature interactively
/write-plan user-authentication          # Create detailed implementation plan
/execute-plan                            # Execute plan with verification checkpoints
/tdd user registration with email        # Start TDD cycle
/debug 500 error on user registration    # Systematic debugging
```

### Review Commands

```bash
/laravel-review app/Http/Controllers     # Code review
/eloquent-optimize app/Models            # N+1 detection
/security-audit                          # Security scan
/test-generate App\Services\UserService  # Generate tests
/make-feature BlogPost --type=api        # Scaffold feature
```

---

## Agents

| Dosya | Agent | Açıklama |
|-------|-------|----------|
| `agents/laravel-reviewer.md` | laravel-reviewer | Comprehensive code review with architecture, security, and Laravel best practices analysis |
| `agents/eloquent-expert.md` | eloquent-expert | N+1 detection, query optimization, index recommendations, relationship analysis |
| `agents/security-auditor.md` | security-auditor | Security vulnerability scanning following OWASP Top 10 guidelines |
| `agents/pest-expert.md` | pest-expert | Pest PHP test patterns, generation, and testing best practices |
| `agents/spec-reviewer.md` | spec-reviewer | Spec compliance verification - checks implementation matches requirements exactly |

---

## Commands

| Dosya | Command | Açıklama |
|-------|---------|----------|
| `commands/brainstorm.md` | `/brainstorm` | Interactive Laravel feature design - Socratic dialogue for requirements gathering |
| `commands/write-plan.md` | `/write-plan <feature>` | Create detailed implementation plan with bite-sized TDD tasks |
| `commands/execute-plan.md` | `/execute-plan [path]` | Execute plan in batches of 3 tasks with verification checkpoints |
| `commands/tdd.md` | `/tdd <description>` | Start TDD cycle - RED (failing test) → GREEN (minimal code) → REFACTOR |
| `commands/debug.md` | `/debug <error>` | Systematic 4-phase debugging: Root cause → Pattern → Hypothesis → Fix |
| `commands/laravel-review.md` | `/laravel-review [path]` | Full code review with architecture, security, and best practices analysis |
| `commands/eloquent-optimize.md` | `/eloquent-optimize [path]` | Analyze queries for N+1, missing indexes, and performance issues |
| `commands/security-audit.md` | `/security-audit` | Security scan for OWASP Top 10 vulnerabilities |
| `commands/test-generate.md` | `/test-generate <class>` | Generate Pest PHP tests for classes or endpoints |
| `commands/make-feature.md` | `/make-feature <name>` | Scaffold complete feature with all Laravel layers |

---

## Skills

### Workflow (Superpowers-style)

| Dosya | Skill | Açıklama |
|-------|-------|----------|
| `skills/workflow/laravel-tdd/SKILL.md` | laravel-tdd | TDD with Pest PHP - RED-GREEN-REFACTOR cycle, AAA pattern, testing checklist |
| `skills/workflow/laravel-tdd/testing-anti-patterns.md` | - | Common testing anti-patterns: mock abuse, N+1 in tests, fragile assertions |
| `skills/workflow/laravel-verification/SKILL.md` | laravel-verification | Verification before completion - tests, pint, phpstan, routes, migrations |
| `skills/workflow/laravel-brainstorming/SKILL.md` | laravel-brainstorming | Interactive feature design - one question at a time, multiple choice, incremental validation |
| `skills/workflow/laravel-planning/SKILL.md` | laravel-planning | Detailed implementation plans - bite-sized tasks, exact file paths, TDD steps |
| `skills/workflow/laravel-executing-plans/SKILL.md` | laravel-executing-plans | Batch execution with checkpoints - 3 tasks per batch, verification between batches |
| `skills/workflow/laravel-systematic-debugging/SKILL.md` | laravel-systematic-debugging | 4-phase debugging: Root cause → Pattern analysis → Hypothesis → Implementation |
| `skills/workflow/laravel-systematic-debugging/common-issues.md` | - | Common Laravel issues: auth, database, queue, cache, testing, performance |

### Design Patterns

| Dosya | Açıklama |
|-------|----------|
| `skills/design-patterns/SKILL.md` | Design patterns overview for Laravel |
| `skills/design-patterns/service-layer.md` | Service Layer pattern - business logic separation |
| `skills/design-patterns/repository-pattern.md` | Repository pattern - data access abstraction |

### Eloquent

| Dosya | Açıklama |
|-------|----------|
| `skills/eloquent/SKILL.md` | Eloquent ORM best practices |
| `skills/eloquent/relationships.md` | All relationship types: hasOne, hasMany, belongsTo, belongsToMany, morphTo |
| `skills/eloquent/query-optimization.md` | Query optimization: eager loading, chunking, indexing, query caching |

### Testing

| Dosya | Açıklama |
|-------|----------|
| `skills/testing/SKILL.md` | Laravel testing with Pest PHP |
| `skills/testing/pest-fundamentals.md` | Pest PHP syntax, expectations, datasets, higher-order tests |
| `skills/testing/feature-tests.md` | HTTP testing patterns for controllers and APIs |

---

## Hooks

### SessionStart

| Dosya | Açıklama |
|-------|----------|
| `hooks/session-start.sh` | Laravel project detection - version, PHP, Pest, PHPStan, Pint availability |

**Triggers:** `startup`, `resume`, `clear`, `compact`

**Actions:**
- Detects if current directory is a Laravel project
- Extracts Laravel version from composer.lock
- Checks for Pest, PHPStan, Pint availability
- Injects context with available skills and commands

### PreToolUse (Safety)

| Matcher | Açıklama |
|---------|----------|
| `migrate:fresh`, `migrate:reset`, `db:wipe` | Warns before destructive database commands |
| `--force` with `migrate` or `db:seed` | Warns before force operations |
| `tinker` with `delete`, `truncate`, `drop` | Warns before destructive tinker commands |

### PostToolUse (Quality)

| Matcher | Açıklama |
|---------|----------|
| Write `.php` file | Checks N+1 patterns, mass assignment, input validation |
| Write `app/Models/*.php` | Checks $fillable, typed relationships, $casts |
| Write `app/Http/Controllers/*.php` | Checks Form Requests, method size, authorization |
| Write `database/migrations/*.php` | Checks foreign key indexes, down() method, nullable columns |
| `php artisan test` fails | Guides to use laravel-systematic-debugging skill |

---

## Rules

| Dosya | Açıklama |
|-------|----------|
| `rules/laravel-conventions.md` | Laravel coding conventions and naming standards |
| `rules/security-rules.md` | Security rules: SQL injection, XSS, CSRF, mass assignment prevention |

---

## Recommended Workflow

```
1. /brainstorm → Design feature interactively
   ↓
2. /write-plan → Create detailed implementation plan
   ↓
3. /execute-plan → Implement with TDD and verification
   │
   ├── Task 1 → TDD → Review → ✓
   ├── Task 2 → TDD → Review → ✓
   └── Task N → TDD → Review → ✓
   ↓
4. Verification → php artisan test
   ↓
5. PR/Merge
```

---

## Directory Structure

```
laravel-claude-code/
├── plugins/
│   └── laravel-claude-code/
│       ├── agents/
│       │   ├── laravel-reviewer.md
│       │   ├── eloquent-expert.md
│       │   ├── security-auditor.md
│       │   ├── pest-expert.md
│       │   └── spec-reviewer.md
│       ├── commands/
│       │   ├── brainstorm.md
│       │   ├── write-plan.md
│       │   ├── execute-plan.md
│       │   ├── tdd.md
│       │   ├── debug.md
│       │   ├── laravel-review.md
│       │   ├── eloquent-optimize.md
│       │   ├── security-audit.md
│       │   ├── test-generate.md
│       │   └── make-feature.md
│       ├── hooks/
│       │   ├── hooks.json
│       │   └── session-start.sh
│       ├── rules/
│       │   ├── laravel-conventions.md
│       │   └── security-rules.md
│       └── skills/
│           ├── design-patterns/
│           │   ├── SKILL.md
│           │   ├── service-layer.md
│           │   └── repository-pattern.md
│           ├── eloquent/
│           │   ├── SKILL.md
│           │   ├── relationships.md
│           │   └── query-optimization.md
│           ├── testing/
│           │   ├── SKILL.md
│           │   ├── pest-fundamentals.md
│           │   └── feature-tests.md
│           └── workflow/
│               ├── laravel-tdd/
│               │   ├── SKILL.md
│               │   └── testing-anti-patterns.md
│               ├── laravel-verification/
│               │   └── SKILL.md
│               ├── laravel-brainstorming/
│               │   └── SKILL.md
│               ├── laravel-planning/
│               │   └── SKILL.md
│               ├── laravel-executing-plans/
│               │   └── SKILL.md
│               └── laravel-systematic-debugging/
│                   ├── SKILL.md
│                   └── common-issues.md
└── README.md
```

---

## Credits

Workflow skills inspired by [obra/superpowers](https://github.com/obra/superpowers) - An agentic skills framework for Claude Code.

## License

MIT
