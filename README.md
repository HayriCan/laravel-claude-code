# Laravel Claude Code Plugin

> Claude Code plugin for Laravel development with code review, Eloquent optimization, security auditing, and Pest testing support.

## Features

- **4 Specialized Agents**: laravel-reviewer, eloquent-expert, security-auditor, pest-expert
- **5 Slash Commands**: /laravel-review, /eloquent-optimize, /security-audit, /test-generate, /make-feature
- **3 Skill Categories**: design-patterns, eloquent, testing
- **Laravel Best Practices**: Conventions and security rules built-in

## Installation

```bash
claude /plugin install github:barcin/laravel-claude-code
```

## Quick Start

### Code Review
```
/laravel-review app/Http/Controllers
```

### Eloquent Optimization
```
/eloquent-optimize app/Models
```

### Security Audit
```
/security-audit
```

### Generate Tests
```
/test-generate App\Services\UserService
```

### Create Feature
```
/make-feature BlogPost --type=api
```

## Agents

| Agent | Purpose |
|-------|---------|
| `laravel-reviewer` | Comprehensive code review with architecture, security, and Laravel best practices |
| `eloquent-expert` | N+1 detection, query optimization, index recommendations |
| `security-auditor` | Security vulnerability scanning following OWASP guidelines |
| `pest-expert` | Pest PHP test patterns and generation |

## Commands

| Command | Description |
|---------|-------------|
| `/laravel-review` | Full code review with actionable recommendations |
| `/eloquent-optimize` | Analyze queries for N+1, missing indexes, performance |
| `/security-audit` | Security scan for OWASP Top 10 vulnerabilities |
| `/test-generate` | Generate Pest PHP tests for classes or endpoints |
| `/make-feature` | Scaffold complete feature with all Laravel layers |

## Skills

### Design Patterns
- Service Layer pattern
- Repository pattern

### Eloquent
- Relationships (all types)
- Query optimization techniques

### Testing
- Pest PHP fundamentals
- Feature test patterns

## Requirements

- Claude Code installed
- Laravel 9+ project
- PHP 8.1+

## License

MIT
