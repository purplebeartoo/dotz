#!/usr/bin/env bash
# Ripgrep search, alias: rs
# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interative-ripgrep-launcher

set -euo pipefail

# Ensure required commands are available
for cmd in rg fzf bat nvim; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' not found in PATH." >&2
    exit 1
  fi
done

# Sanitize INITIAL_QUERY by disallowing unsafe characters
INITIAL_QUERY="$*"
if [[ "$INITIAL_QUERY" =~ [\'\"\$\(\)\;\|\&\`\\] ]]; then
  echo "Error: Query contains potentially unsafe characters." >&2
  exit 1
fi

RG_PREFIX=(
  rg
  --color=always
  --column
  --glob='!.var'
  --glob='!containers'
  --glob='!timeshift'
  --hidden
  --line-number
  --no-heading
  --smart-case
)

fzf --ansi --disabled --query "$INITIAL_QUERY" \
  --bind "start:reload:${RG_PREFIX[*]} {q}" \
  --bind "change:reload:sleep 0.1; ${RG_PREFIX[*]} {q} || true" \
  --delimiter : \
  --preview 'bat --color=always {1} --highlight-line {2}' \
  --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
  --bind 'enter:become(nvim {1} +{2})'
