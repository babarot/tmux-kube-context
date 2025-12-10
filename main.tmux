#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get user configuration or use defaults
kube_color=$(tmux show-option -gqv "@kube-context-color")
kube_color=${kube_color:-"blue"}

kube_bold=$(tmux show-option -gqv "@kube-context-bold")
kube_bold=${kube_bold:-"bold"}

# Format the display string
display_format="#[fg=${kube_color}"
if [ -n "${kube_bold}" ]; then
  display_format="${display_format},${kube_bold}"
fi
display_format="${display_format}](#(${CURRENT_DIR}/kube-context))#[default] "

# Set status-left with kube context
tmux set-option -g status-left "${display_format}"
