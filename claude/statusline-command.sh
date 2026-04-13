#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON input
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
style=$(echo "$input" | jq -r '.output_style.name')
transcript_path=$(echo "$input" | jq -r '.transcript_path')

# Get user and hostname
user=$(whoami)
host=$(cat /etc/hostname 2>/dev/null || echo "unknown")

# Get git information
git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || echo '')
git_status=''
if [ -n "$git_branch" ]; then
    if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
        git_status=' *'
    fi
    git_branch=" :: $git_branch$git_status"
fi

# Calculate context size and usage limits information
context_info=""
usage_info=""

# Context window percentage from Claude Code's built-in data
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Color based on usage: green < 50%, yellow 50-80%, red > 80%
if [ "$ctx_pct" -gt 80 ] 2>/dev/null; then
    ctx_color="\033[91m"
elif [ "$ctx_pct" -gt 50 ] 2>/dev/null; then
    ctx_color="\033[93m"
else
    ctx_color="\033[92m"
fi

context_info=$(printf " \033[90m|\033[0m ${ctx_color}%s%% ctx\033[0m" "$ctx_pct")

# Extract usage limits information from JSON input
rate_limit=$(echo "$input" | jq -r '.usage_limits.rate_limit // empty' 2>/dev/null)
token_limit=$(echo "$input" | jq -r '.usage_limits.token_limit // empty' 2>/dev/null)
requests_remaining=$(echo "$input" | jq -r '.usage_limits.requests_remaining // empty' 2>/dev/null)
tokens_remaining=$(echo "$input" | jq -r '.usage_limits.tokens_remaining // empty' 2>/dev/null)
reset_time=$(echo "$input" | jq -r '.usage_limits.reset_time // empty' 2>/dev/null)

# Build usage limits display
usage_parts=""
if [ -n "$requests_remaining" ] && [ "$requests_remaining" != "null" ]; then
    if [ "$requests_remaining" -lt 10 ]; then
        # Red for low remaining requests
        usage_parts="$usage_parts$(printf "\033[91m%sreq\033[0m" "$requests_remaining")"
    elif [ "$requests_remaining" -lt 50 ]; then
        # Yellow for medium remaining requests
        usage_parts="$usage_parts$(printf "\033[93m%sreq\033[0m" "$requests_remaining")"
    else
        # Green for plenty of remaining requests
        usage_parts="$usage_parts$(printf "\033[92m%sreq\033[0m" "$requests_remaining")"
    fi
fi

if [ -n "$tokens_remaining" ] && [ "$tokens_remaining" != "null" ]; then
    # Format token count
    if [ "$tokens_remaining" -gt 1000000 ]; then
        token_remaining_display=$(echo "$tokens_remaining" | awk '{printf "%.1fM", $1/1000000}')
    elif [ "$tokens_remaining" -gt 1000 ]; then
        token_remaining_display=$(echo "$tokens_remaining" | awk '{printf "%.1fK", $1/1000}')
    else
        token_remaining_display="${tokens_remaining}"
    fi

    if [ "$tokens_remaining" -lt 10000 ]; then
        # Red for low remaining tokens
        usage_parts="$usage_parts$(printf "\033[91m%stok\033[0m" "$token_remaining_display")"
    elif [ "$tokens_remaining" -lt 50000 ]; then
        # Yellow for medium remaining tokens
        usage_parts="$usage_parts$(printf "\033[93m%stok\033[0m" "$token_remaining_display")"
    else
        # Green for plenty of remaining tokens
        usage_parts="$usage_parts$(printf "\033[92m%stok\033[0m" "$token_remaining_display")"
    fi
fi

# Add reset time if available and limits are low
if [ -n "$reset_time" ] && [ "$reset_time" != "null" ] && [ -n "$usage_parts" ]; then
    # Parse reset time and calculate minutes until reset
    if command -v date >/dev/null 2>&1; then
        current_time=$(date +%s 2>/dev/null)
        reset_timestamp=$(date -d "$reset_time" +%s 2>/dev/null || echo "")
        if [ -n "$reset_timestamp" ] && [ -n "$current_time" ]; then
            time_diff=$((reset_timestamp - current_time))
            if [ "$time_diff" -gt 0 ] && [ "$time_diff" -lt 3600 ]; then
                minutes_left=$((time_diff / 60))
                usage_parts="$usage_parts$(printf "\033[90m%sm\033[0m" "$minutes_left")"
            fi
        fi
    fi
fi

# Format final usage info
if [ -n "$usage_parts" ]; then
    usage_info=$(printf " \033[90m|\033[0m%s" "$usage_parts")
fi

# Print the status line with colors
printf "\033[33m%s\033[0m@\033[32m%s\033[0m \033[90m::\033[0m \033[37m%s\033[0m\033[35m%s\033[0m \033[90m|\033[0m \033[36m%s\033[0m%s%s\n" \
    "$user" "$host" "$(basename "$cwd")" "$git_branch" "$model" "$context_info" "$usage_info"
