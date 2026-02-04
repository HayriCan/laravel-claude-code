---
description: Security audit following OWASP guidelines and Laravel security best practices
argument-hint: [scope] [--severity=critical|all]
---

# Security Audit

Perform a comprehensive security analysis of your Laravel application.

## Usage

```
/security-audit                    # Full application audit
/security-audit app/Http           # Audit HTTP layer only
/security-audit --severity=critical # Only critical vulnerabilities
```

## Audit Scope

### OWASP Top 10 Coverage
1. **Injection** - SQL, Command, LDAP injection
2. **Broken Authentication** - Session management, password policies
3. **Sensitive Data Exposure** - Encryption, data leakage
4. **XML External Entities** - XXE vulnerabilities
5. **Broken Access Control** - Authorization bypasses
6. **Security Misconfiguration** - Debug mode, headers
7. **XSS** - Cross-site scripting
8. **Insecure Deserialization** - Object injection
9. **Vulnerable Components** - Dependency vulnerabilities
10. **Insufficient Logging** - Audit trail gaps

### Laravel-Specific Checks
- Mass assignment protection
- CSRF token validation
- Form Request usage
- Policy implementation
- Encryption configuration
- Session security

## Output

Generates a vulnerability report with:
- Critical vulnerabilities (immediate action)
- Medium risks (should fix)
- Low risks / informational
- Security score (A-F)
- Remediation steps

## Quick Fixes

The audit will suggest specific code changes for each vulnerability found.

Launch the `security-auditor` agent with scope: $ARGUMENTS
