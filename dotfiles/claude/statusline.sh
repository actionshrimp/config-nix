#!/bin/bash
# Claude Code custom statusline with usage limits and upgrade indicator
#
# Reads OAuth token from macOS Keychain (stored by Claude Code)

set -eo pipefail

# Read JSON input from Claude Code
INPUT=$(cat)

# Configuration
CACHE_DIR="$HOME/.claude/cache/statusline"
USAGE_CACHE="$CACHE_DIR/usage.json"
UPGRADE_CACHE="$CACHE_DIR/upgrade.txt"
USAGE_CACHE_TTL=60      # seconds - refresh usage every minute
UPGRADE_CACHE_TTL=3600  # seconds - check upgrades every hour

# Colors (ANSI)
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Get OAuth token from macOS Keychain
get_oauth_token() {
    local creds
    creds=$(security find-generic-password -s "Claude Code-credentials" -a "$(whoami)" -w 2>/dev/null) || return 1
    echo "$creds" | jq -r '.claudeAiOauth.accessToken // empty'
}

# Progress bar function using Unicode blocks
# Usage: progress_bar <percentage> <width> <color>
progress_bar() {
    local percent=${1:-0}
    local width=${2:-10}
    local color=${3:-$GREEN}

    # Clamp percentage
    (( percent < 0 )) && percent=0
    (( percent > 100 )) && percent=100

    # Calculate filled/empty blocks
    local filled=$(( (percent * width + 50) / 100 ))
    local empty=$(( width - filled ))

    # Choose color based on percentage
    if (( percent >= 80 )); then
        color=$RED
    elif (( percent >= 50 )); then
        color=$YELLOW
    else
        color=$GREEN
    fi

    # Build bar using block characters
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    echo -e "${color}${bar}${RESET}"
}

# Check if cache is valid
cache_valid() {
    local cache_file="$1"
    local ttl="$2"

    if [[ ! -f "$cache_file" ]]; then
        return 1
    fi

    local now=$(date +%s)
    local mtime=$(stat -c "%Y" "$cache_file" 2>/dev/null || stat -f "%m" "$cache_file" 2>/dev/null || echo 0)
    local age=$(( now - mtime ))

    (( age < ttl ))
}

# Fetch usage from OAuth API
fetch_usage() {
    if cache_valid "$USAGE_CACHE" "$USAGE_CACHE_TTL"; then
        cat "$USAGE_CACHE"
        return
    fi

    local token
    token=$(get_oauth_token)
    if [[ -z "$token" ]]; then
        echo '{"error":"no_token"}'
        return
    fi

    local response
    response=$(curl -s --max-time 3 \
        -H "Authorization: Bearer $token" \
        -H "anthropic-beta: oauth-2025-04-20" \
        -H "Accept: application/json" \
        "https://api.anthropic.com/api/oauth/usage" 2>/dev/null) || response='{"error":"fetch_failed"}'

    # Cache if successful
    if echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
        echo "$response" > "$USAGE_CACHE"
    fi

    echo "$response"
}

# Check for upgrade availability
check_upgrade() {
    if cache_valid "$UPGRADE_CACHE" "$UPGRADE_CACHE_TTL"; then
        cat "$UPGRADE_CACHE"
        return
    fi

    local current_version=$(echo "$INPUT" | jq -r '.version // empty')
    if [[ -z "$current_version" ]]; then
        current_version=$(claude --version 2>/dev/null | head -1 | awk '{print $1}')
    fi

    # Fetch latest version from npm (with timeout)
    local latest_version
    latest_version=$(npm view @anthropic-ai/claude-code version 2>/dev/null) || latest_version=""

    local result="none"
    if [[ -n "$latest_version" && -n "$current_version" && "$latest_version" != "$current_version" ]]; then
        result="available:$latest_version"
    fi

    echo "$result" > "$UPGRADE_CACHE"
    echo "$result"
}

# Extract context window percentage from input
get_context_percent() {
    echo "$INPUT" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}'
}

# Get effort level from settings
get_effort_level() {
    local settings_file="$HOME/.claude/settings.json"
    if [[ -f "$settings_file" ]]; then
        local level=$(jq -r '.effortLevel // empty' "$settings_file" 2>/dev/null)
        if [[ -n "$level" ]]; then
            echo "$level"
            return
        fi
    fi
    echo "high"  # default
}

# Main statusline generation
main() {
    local output=""

    # Get model name + effort level
    local model=$(echo "$INPUT" | jq -r '.model.display_name // "?"')
    local effort=$(get_effort_level)
    local effort_color=$GREEN
    case "$effort" in
        low)    effort_color=$DIM ;;
        medium) effort_color=$YELLOW ;;
        high)   effort_color=$GREEN ;;
    esac
    output+="${CYAN}${model}${RESET} ${effort_color}${effort}${RESET}  "

    # Context window progress bar
    local ctx_percent=$(get_context_percent)
    output+="ctx:$(progress_bar "$ctx_percent" 8) "
    output+="${DIM}${ctx_percent}%${RESET}    "

    # Fetch usage from OAuth API
    local usage=$(fetch_usage)

    if echo "$usage" | jq -e '.five_hour' >/dev/null 2>&1; then
        # Session (5-hour) limit
        local session_percent=$(echo "$usage" | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
        output+="5h:$(progress_bar "$session_percent" 6) "
        output+="${DIM}${session_percent}%${RESET}    "

        # Weekly (7-day) limit
        local weekly_percent=$(echo "$usage" | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
        output+="7d:$(progress_bar "$weekly_percent" 6) "
        output+="${DIM}${weekly_percent}%${RESET} "
    else
        # Not configured or error
        output+="${DIM}5h:--- 7d:---${RESET} "
    fi

    # Check for upgrade (may use cache)
    local upgrade_status=$(check_upgrade)
    if [[ "$upgrade_status" == available:* ]]; then
        output+="⬆️"
    fi

    echo -e "$output"
}

main
