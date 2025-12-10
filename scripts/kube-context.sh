#!/usr/bin/env bash

set -eo pipefail

# Ensure common binary paths are available
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:${PATH}"

# Helper function to get tmux option
get_tmux_option() {
  local option="$1"
  local default="$2"
  local value
  value="$(tmux show-option -gqv "${option}" 2>/dev/null)"
  echo "${value:-${default}}"
}

# Check if kubectl is available
if ! command -v kubectl &>/dev/null; then
  echo "N/A"
  exit 0
fi

# Get current context
if ! context="$(kubectl config current-context 2>/dev/null)"; then
  echo "N/A"
  exit 0
fi

# Get namespace for the current context
namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${context}\")].context.namespace}" 2>/dev/null)"
if [[ -z "${namespace}" ]]; then
  namespace="default"
fi

# Strip cloud provider region suffixes and format for cleaner display
# Handles common patterns from GCP, AWS, Azure
# Examples:
#   - GCP: gke_project_asia-northeast1-a_cluster -> project:cluster
#   - AWS: arn:aws:eks:us-west-2:account:cluster/name -> name
#   - Azure: aks_project_eastus_cluster -> project:cluster

# Detect cloud provider and apply appropriate formatting
case "${context}" in
  gke_*)
    # GCP: Remove gke_ prefix and region pattern
    context="${context#gke_}"
    # Remove GCP-style region patterns: _region-zone_ or _region-zone at the end
    # Pattern matches: _word-word+digits-letter[_] (e.g., _asia-northeast1-a_)
    context="$(echo "${context}" | sed -E 's/_[a-z]+-[a-z]+[0-9]+-[a-z]_/_/g; s/_[a-z]+-[a-z]+[0-9]+-[a-z]$//')"
    # Replace underscore with colon for readability (project:cluster)
    context="${context/_/:}"
    ;;
  aks_*)
    # Azure: Remove aks_ prefix and region pattern
    context="${context#aks_}"
    # Remove Azure-style regions: _eastus_, _westus_, _eastus2_, etc.
    # Format is typically: project_region_cluster
    context="$(echo "${context}" | sed -E 's/_(east|west|central|north|south)(us|eu|asia|uk|au|in|japan|korea|canada|france|germany|brazil|uae)[0-9]*_/_/')"
    # Replace underscore with colon for readability (project:cluster)
    context="${context/_/:}"
    ;;
  arn:aws:eks:*|eks_*)
    # AWS: Handle ARN format or eks_ prefix
    context="${context##*/}"  # Remove path-like prefixes (for ARN)
    context="${context#eks_}"
    # Remove AWS-style region patterns: _region-zone_ (middle) or at the end
    # Pattern matches: _word-word-digits[_] (e.g., _us-west-2_)
    context="$(echo "${context}" | sed -E 's/_[a-z]+-[a-z]+-[0-9]+_/_/g; s/_[a-z]+-[a-z]+-[0-9]+$//')"
    # Replace underscore with colon for readability (project:cluster)
    context="${context/_/:}"
    ;;
  *)
    # Other providers or local clusters (minikube, kind, etc.) - no transformation
    :
    ;;
esac

# Get prefix and suffix for display format
prefix="$(get_tmux_option "@kube-context-prefix" "(")"
suffix="$(get_tmux_option "@kube-context-suffix" ")")"

echo "${prefix}${context}/${namespace}${suffix}"
