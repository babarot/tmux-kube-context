#!/usr/bin/env bash

set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get user configuration or use defaults
get_tmux_option() {
  local option="$1"
  local default="$2"
  local value
  value="$(tmux show-option -gqv "${option}")"
  echo "${value:-${default}}"
}

# Check if plugin should be enabled on this host
enabled_hosts="$(get_tmux_option "@kube-context-enabled-hosts" "")"
if [[ -n "${enabled_hosts}" ]]; then
  current_host="$(hostname -s 2>/dev/null || hostname)"
  # Check if current hostname is in the enabled list
  if [[ ! " ${enabled_hosts} " =~ " ${current_host} " ]]; then
    # Host not in whitelist, exit without setting status-left
    exit 0
  fi
fi

kube_bg="$(get_tmux_option "@kube-context-bg" "default")"
kube_fg="$(get_tmux_option "@kube-context-fg" "blue")"
kube_bold="$(get_tmux_option "@kube-context-bold" "")"
kube_separator="$(get_tmux_option "@kube-context-separator" "")"

# Build display format string
display_format="#[bg=${kube_bg},fg=${kube_fg}"
[[ -n "${kube_bold}" ]] && display_format="${display_format},${kube_bold}"
display_format="${display_format}] (#(${CURRENT_DIR}/kube-context)) "

# Add separator if configured
if [[ -n "${kube_separator}" ]]; then
  display_format="${display_format}#[bg=default,fg=${kube_bg}]${kube_separator}#[default] "
else
  display_format="${display_format}#[default]"
fi

# Set status-left with kube context
tmux set-option -g status-left "${display_format}"
