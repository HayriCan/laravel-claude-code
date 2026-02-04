---
description: Analyze and optimize Eloquent queries for N+1 prevention, indexing, and performance
argument-hint: [file-or-directory] [--generate-migration]
---

# Eloquent Optimization

Analyze Eloquent usage and provide optimization recommendations.

## Usage

```
/eloquent-optimize                       # Analyze all models and controllers
/eloquent-optimize app/Models            # Analyze models only
/eloquent-optimize app/Http/Controllers  # Analyze controllers
/eloquent-optimize --generate-migration  # Generate index migration
```

## Analysis Targets

1. **N+1 Query Detection**
   - Loops with relationship access
   - Missing `with()` calls
   - Lazy loading in iterations

2. **Query Efficiency**
   - `SELECT *` vs specific columns
   - `count()` vs `exists()`
   - Missing pagination

3. **Index Analysis**
   - Foreign keys without indexes
   - Frequently filtered columns
   - Composite index opportunities

4. **Memory Optimization**
   - Large dataset handling
   - Chunking recommendations
   - Cursor usage opportunities

## Output

Generates a report with:
- N+1 queries with exact locations and fixes
- Missing indexes with migration code
- Query optimization suggestions
- Estimated performance impact

## Options

- `--generate-migration`: Create a migration file with recommended indexes

Launch the `eloquent-expert` agent with scope: $ARGUMENTS
