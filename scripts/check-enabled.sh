#!/usr/bin/env bash

set -eo pipefail

# Helper function to get tmux option
get_tmux_option() {
  local option="$1"
  local default="$2"
  local value
  value="$(tmux show-option -gqv "${option}" 2>/dev/null)"
  echo "${value:-${default}}"
}

# Check if plugin should be enabled on this host
enabled_hosts="$(get_tmux_option "@kube-context-enabled-hosts" "")"
if [[ -n "${enabled_hosts}" ]]; then
  current_host="$(hostname -s 2>/dev/null || hostname)"
  # Check if current hostname is in the enabled list
  if [[ ! " ${enabled_hosts} " =~ " ${current_host} " ]]; then
    # Host not in whitelist
    exit 1
  fi
fi

# Check if plugin should be enabled in current directory
enabled_dirs="$(get_tmux_option "@kube-context-enabled-dirs" "")"
if [[ -n "${enabled_dirs}" ]]; then
  current_dir="$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || pwd)"
  dir_matched=false
  # Check if current directory is under any of the enabled directories
  for dir in ${enabled_dirs}; do
    # Expand tilde to home directory
    dir="${dir/#\~/$HOME}"
    case "${current_dir}" in
      "${dir}"*)
        dir_matched=true
        break
        ;;
    esac
  done
  if [[ "${dir_matched}" != "true" ]]; then
    # Directory not in whitelist
    exit 1
  fi
fi

# All conditions met
exit 0
