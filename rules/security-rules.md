# Security Rules

Security requirements and best practices for Laravel applications.

## Input Validation

### Always Use Form Requests
```php
// Good
public function store(StoreUserRequest $request)
{
    User::create($request->validated());
}

// Bad
public function store(Request $request)
{
    User::create($request->all());
}
```

### Validation Rules
```php
public function rules(): array
{
    return [
        'email' => ['required', 'email', 'unique:users'],
        'password' => ['required', 'min:8', 'confirmed'],
        'role' => ['required', Rule::in(['user', 'admin'])],
        'avatar' => ['nullable', 'image', 'mimes:jpg,png', 'max:2048'],
    ];
}
```

## Database Security

### Never Use Raw Queries with User Input
```php
// VULNERABLE - SQL Injection
DB::select("SELECT * FROM users WHERE email = '" . $request->email . "'");

// SAFE - Parameterized
DB::select("SELECT * FROM users WHERE email = ?", [$request->email]);

// SAFE - Eloquent
User::where('email', $request->email)->first();
```

### Mass Assignment Protection
```php
// Good - Explicit fillable
protected $fillable = ['name', 'email'];

// Good - Validated data only
User::create($request->validated());

// Bad - All input
User::create($request->all());

// NEVER
protected $guarded = [];
```

## Authentication

### Password Hashing
```php
// Always hash passwords
$user->password = Hash::make($password);

// Verify passwords
if (Hash::check($password, $user->password)) {
    // Authenticated
}
```

### Throttle Login Attempts
```php
// In RouteServiceProvider or auth controller
RateLimiter::for('login', function (Request $request) {
    return Limit::perMinute(5)->by($request->email . $request->ip());
});
```

### Session Security
```php
// config/session.php
'secure' => env('SESSION_SECURE_COOKIE', true),
'http_only' => true,
'same_site' => 'lax',

// Regenerate session after login
$request->session()->regenerate();
```

## Authorization

### Use Policies
```php
// Define policy
class PostPolicy
{
    public function update(User $user, Post $post): bool
    {
        return $user->id === $post->user_id;
    }
}

// Use in controller
public function update(UpdatePostRequest $request, Post $post)
{
    $this->authorize('update', $post);
    // ...
}
```

### Protect Admin Routes
```php
Route::middleware(['auth', 'admin'])->prefix('admin')->group(function () {
    Route::resource('users', AdminUserController::class);
});
```

## XSS Prevention

### Blade Escaping
```php
// SAFE - Auto escaped
{{ $userInput }}

// DANGEROUS - Only use for trusted HTML
{!! $trustedHtml !!}

// SAFE - Manual escape
{!! e($userInput) !!}
```

### JSON Responses
```php
// Laravel automatically escapes JSON
return response()->json(['message' => $userInput]);
```

## CSRF Protection

### Forms
```blade
<form method="POST">
    @csrf
    <!-- form fields -->
</form>
```

### AJAX Requests
```javascript
// Include token in headers
axios.defaults.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').content;
```

## File Upload Security

```php
public function rules(): array
{
    return [
        'file' => [
            'required',
            'file',
            'mimes:pdf,doc,docx',
            'max:10240', // 10MB
        ],
        'image' => [
            'required',
            'image',
            'mimes:jpg,jpeg,png,gif',
            'max:2048',
            'dimensions:max_width=2000,max_height=2000',
        ],
    ];
}

// Store with random name
$path = $request->file('document')->store('documents');
```

## Sensitive Data

### Hide in Responses
```php
class User extends Model
{
    protected $hidden = [
        'password',
        'remember_token',
        'two_factor_secret',
    ];
}
```

### Don't Log Sensitive Data
```php
// Bad
Log::info('User login', $request->all()); // Logs password!

// Good
Log::info('User login', ['email' => $request->email]);
```

### Environment Variables
```php
// Never commit secrets
// .env (not in git)
API_SECRET=your-secret-key

// Access via config
config('services.api.secret')
```

## Security Headers

```php
// In middleware or config/cors.php
return [
    'X-Frame-Options' => 'SAMEORIGIN',
    'X-Content-Type-Options' => 'nosniff',
    'X-XSS-Protection' => '1; mode=block',
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
    'Content-Security-Policy' => "default-src 'self'",
];
```

## Production Checklist

- [ ] `APP_DEBUG=false`
- [ ] `APP_ENV=production`
- [ ] Strong `APP_KEY`
- [ ] HTTPS enforced
- [ ] Secure session cookies
- [ ] Rate limiting enabled
- [ ] `composer audit` clean
- [ ] Error pages don't leak info
- [ ] Logs don't contain secrets
- [ ] Backups encrypted
