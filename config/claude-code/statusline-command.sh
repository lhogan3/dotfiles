#!/bin/bash
# Claude Code status line
# Shows: model | dir (git branch) | context used% | 5h/7d rate-limit usage

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "~"')
dir_name=$(basename "$cwd")

git_branch=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -z "$git_branch" ]; then
    git_branch=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
fi

context_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Dim ANSI colors (safe on both light/dark terminal backgrounds)
DIM='\033[2m'
CYAN='\033[2;36m'
YELLOW='\033[2;33m'
MAGENTA='\033[2;35m'
RESET='\033[0m'

printf "${CYAN}%s${RESET} ${DIM}|${RESET} ${DIM}%s" "$model" "$dir_name"

if [ -n "$git_branch" ]; then
  printf " ${YELLOW}(%s)${RESET}" "$git_branch"
fi

if [ -n "$context_used" ]; then
  printf " ${DIM}|${RESET} ${MAGENTA}ctx: %.0f%%${RESET}" "$context_used"
fi

if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
  printf " ${DIM}|${RESET}"
  [ -n "$five_hour" ] && printf " ${DIM}5h: %.0f%%${RESET}" "$five_hour"
  [ -n "$seven_day" ] && printf " ${DIM}7d: %.0f%%${RESET}" "$seven_day"
fi

printf "\n"
