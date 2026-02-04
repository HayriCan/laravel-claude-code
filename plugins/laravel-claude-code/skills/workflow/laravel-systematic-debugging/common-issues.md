# Common Laravel Issues and Solutions

## Authentication Issues

### 401 Unauthorized
```bash
# Check
php artisan route:list --name=api
# Look for auth:sanctum or auth middleware
```

**Causes:**
- Missing Bearer token
- Expired token
- Wrong guard configured

**Investigation:**
```php
// In controller
Log::debug('Auth check', [
    'authenticated' => Auth::check(),
    'guard' => Auth::getDefaultDriver(),
    'user' => Auth::user(),
]);
```

### 419 Page Expired
**Cause:** CSRF token missing or expired

**For Forms:**
```blade
<form method="POST">
    @csrf
    ...
</form>
```

**For AJAX:**
```javascript
// Add to headers
'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
```

## Database Issues

### N+1 Query Problem
**Symptom:** Many similar queries in log

**Investigation:**
```php
DB::enableQueryLog();
$users = User::all();
foreach ($users as $user) {
    echo $user->posts->count(); // N+1!
}
dd(DB::getQueryLog()); // See all queries
```

**Fix:**
```php
$users = User::with('posts')->get();
```

### Mass Assignment Exception
**Symptom:** `MassAssignmentException`

**Fix:**
```php
// In Model
protected $fillable = ['name', 'email'];
// OR
protected $guarded = ['id'];
```

### Foreign Key Constraint
**Symptom:** `SQLSTATE[23000]: Integrity constraint violation`

**Investigation:**
```bash
php artisan tinker
>>> \DB::select('SHOW CREATE TABLE posts');
```

**Common fixes:**
- Create parent record first
- Use `cascadeOnDelete()` in migration
- Check column types match (bigint vs int)

## Queue Issues

### Jobs Not Processing
```bash
# Check if worker is running
ps aux | grep "queue:work"

# Process one job manually
php artisan queue:work --once

# Check failed jobs
php artisan queue:failed
```

### Job Keeps Failing
```bash
# Get failure reason
php artisan queue:failed

# Retry specific job
php artisan queue:retry <id>

# Retry all failed
php artisan queue:retry all
```

**Common causes:**
- Missing dependencies (service not bound)
- Database connection timeout
- Memory limit exceeded

## Cache Issues

### Stale Data
```bash
# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Or all at once
php artisan optimize:clear
```

### Config Not Updating
```bash
# After changing .env
php artisan config:clear

# If using config:cache in production
php artisan config:cache
```

## Testing Issues

### Database State Pollution
**Symptom:** Tests pass individually, fail together

**Fix:**
```php
uses(RefreshDatabase::class);
```

### Factory State Issues
**Symptom:** `BadMethodCallException: Call to undefined method`

**Fix:**
```php
// Check factory exists
ls database/factories/

// Check state method
// In ModelFactory.php
public function stateName(): Factory
{
    return $this->state(fn () => [...]);
}
```

### Mocking Issues
**Symptom:** Real service called instead of mock

**Fix:**
```php
// Bind mock BEFORE resolving service
$mock = Mockery::mock(Service::class);
$this->app->instance(Service::class, $mock);

// Now get service
$service = app(Service::class);
```

## Performance Issues

### Slow Queries
**Investigation:**
```php
// Log slow queries
DB::listen(function ($query) {
    if ($query->time > 100) { // ms
        Log::warning('Slow query', [
            'sql' => $query->sql,
            'time' => $query->time,
        ]);
    }
});
```

**Common fixes:**
- Add database indexes
- Use eager loading
- Paginate large results
- Cache expensive queries

### Memory Issues
**Symptom:** `Allowed memory size exhausted`

**Investigation:**
```php
// Check memory usage
Log::debug('Memory', [
    'usage' => memory_get_usage(true) / 1024 / 1024 . ' MB'
]);
```

**Fixes:**
- Use `chunk()` for large datasets
- Remove `->get()` when not needed
- Use `cursor()` for streaming

## Debugging Commands

```bash
# Check environment
php artisan about

# Check routes
php artisan route:list

# Check scheduled tasks
php artisan schedule:list

# Check queue
php artisan queue:monitor

# Interactive debugging
php artisan tinker
```
