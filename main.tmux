#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get user configuration or use generic defaults
kube_bg=$(tmux show-option -gqv "@kube-context-bg")
kube_bg=${kube_bg:-"default"}

kube_fg=$(tmux show-option -gqv "@kube-context-fg")
kube_fg=${kube_fg:-"blue"}

kube_bold=$(tmux show-option -gqv "@kube-context-bold")
kube_bold=${kube_bold:-""}

kube_separator=$(tmux show-option -gqv "@kube-context-separator")
kube_separator=${kube_separator:-""}

# Format the display string
display_format="#[bg=${kube_bg},fg=${kube_fg}"
if [ -n "${kube_bold}" ]; then
  display_format="${display_format},${kube_bold}"
fi
display_format="${display_format}] (#(${CURRENT_DIR}/kube-context)) "

# Add separator if configured
if [ -n "${kube_separator}" ]; then
  display_format="${display_format}#[bg=default,fg=${kube_bg}]${kube_separator}#[default] "
else
  display_format="${display_format}#[default]"
fi

# Set status-left with kube context
tmux set-option -g status-left "${display_format}"
