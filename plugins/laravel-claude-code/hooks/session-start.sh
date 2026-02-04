#!/usr/bin/env bash
# SessionStart hook for Laravel Claude Code plugin
# Detects Laravel project and provides context

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Initialize variables
laravel_info=""
project_type="unknown"
laravel_version=""

# Check if current directory is a Laravel project
if [ -f "artisan" ] && [ -f "composer.json" ]; then
    project_type="laravel"

    # Get Laravel version from composer.lock
    if [ -f "composer.lock" ]; then
        laravel_version=$(grep -A5 '"name": "laravel/framework"' composer.lock 2>/dev/null | grep '"version"' | head -1 | sed 's/.*"version": "\([^"]*\)".*/\1/' || echo "unknown")
    fi

    # Get PHP version
    php_version=$(php -v 2>/dev/null | head -1 | awk '{print $2}' || echo "unknown")

    # Check for Pest
    has_pest="no"
    if [ -f "vendor/bin/pest" ] || grep -q "pestphp/pest" composer.json 2>/dev/null; then
        has_pest="yes"
    fi

    # Check for PHPStan
    has_phpstan="no"
    if [ -f "vendor/bin/phpstan" ] || grep -q "phpstan/phpstan" composer.json 2>/dev/null; then
        has_phpstan="yes"
    fi

    # Check for Pint
    has_pint="no"
    if [ -f "vendor/bin/pint" ] || grep -q "laravel/pint" composer.json 2>/dev/null; then
        has_pint="yes"
    fi

    laravel_info="Laravel ${laravel_version} | PHP ${php_version} | Pest: ${has_pest} | PHPStan: ${has_phpstan} | Pint: ${has_pint}"
fi

# Escape outputs for JSON using pure bash
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\\\' ;;
            '"') output+='\\"' ;;
            $'\n') output+='\\n' ;;
            $'\r') output+='\\r' ;;
            $'\t') output+='\\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}

# Build context message
context_message=""
if [ "$project_type" = "laravel" ]; then
    context_message="<laravel-context>
You are working in a Laravel project.

**Environment:** ${laravel_info}

**Available Skills:**
- laravel-tdd: TDD with Pest PHP (RED-GREEN-REFACTOR)
- laravel-verification: Verification before completion
- laravel-brainstorming: Feature design workflow
- laravel-planning: Implementation planning
- laravel-systematic-debugging: 4-phase debugging

**Available Commands:**
- /tdd <description> - Start TDD cycle
- /brainstorm - Design new feature
- /write-plan <feature> - Create implementation plan
- /execute-plan - Execute plan in batches
- /debug <error> - Systematic debugging

**Quick Verification:**
\`\`\`bash
php artisan test && ./vendor/bin/pint --test && ./vendor/bin/phpstan analyse
\`\`\`
</laravel-context>"
fi

context_escaped=$(escape_for_json "$context_message")

# Output context injection as JSON
if [ -n "$context_message" ]; then
    cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${context_escaped}"
  }
}
EOF
else
    echo "{}"
fi

exit 0
