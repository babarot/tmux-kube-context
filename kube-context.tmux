#!/usr/bin/env bash

set -e

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Save the original status-left before overwriting
original_status_left="$(tmux show-option -gqv status-left)"
tmux set-option -g @kube-context-original-status-left "${original_status_left}"

# Set status-left to call kube-context.sh
# The script will handle condition checking and formatting
tmux set-option -g status-left "#(${CURRENT_DIR}/scripts/kube-context.sh)"
