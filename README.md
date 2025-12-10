# tmux-kube-context

A tmux plugin that displays the current Kubernetes context and namespace in the status bar.

![](https://img.shields.io/badge/tmux-plugin-blue)

## Features

- Displays current Kubernetes context and namespace
- Automatically updates based on your kubectl configuration
- Customizable colors and formatting
- Strips GCP region suffixes for cleaner display

## Installation

### Using [TPM](https://github.com/tmux-plugins/tpm) (recommended)

Add the following line to your `~/.tmux.conf`:

```tmux
set -g @plugin 'babarot/tmux-kube-context'
```

Then press `prefix + I` to install the plugin.

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/babarot/tmux-kube-context ~/.tmux/plugins/tmux-kube-context
   ```

2. Source the plugin in your `~/.tmux.conf`:
   ```tmux
   run '~/.tmux/plugins/tmux-kube-context/main.tmux'
   ```

3. Reload tmux configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

## Configuration

The plugin supports the following options (set in your `~/.tmux.conf`):

### Foreground Color

Set the text color of the Kubernetes context display:

```tmux
set -g @kube-context-fg 'blue'
```

Default: `blue`

Available colors: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, or any color code.

### Background Color

Set the background color of the Kubernetes context display:

```tmux
set -g @kube-context-bg 'default'
```

Default: `default`

### Bold

Enable or disable bold formatting:

```tmux
set -g @kube-context-bold 'bold'
```

Default: empty (no bold)

To enable bold:

```tmux
set -g @kube-context-bold 'bold'
```

### Separator

Add a separator character after the Kubernetes context:

```tmux
set -g @kube-context-separator ''
```

Default: empty (no separator)

For powerline-style separators:

```tmux
set -g @kube-context-separator ''
```

## Example Configuration

```tmux
# In your ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'babarot/tmux-kube-context'

# Customize appearance
set -g @kube-context-fg 'cyan'
set -g @kube-context-bg 'black'
set -g @kube-context-bold 'bold'
set -g @kube-context-separator ''

# Initialize TPM (keep this at the bottom)
run '~/.tmux/plugins/tpm/tpm'
```

## Display Format

The plugin displays the context and namespace in the following format:

```
(project:cluster/namespace)
```

For example:
- `(myproject:production/default)`
- `(minikube/kube-system)`

Cloud provider prefixes and region suffixes are automatically stripped and formatted for cleaner display:
- GCP: `gke_project_asia-northeast1-a_cluster` → `project:cluster`
- AWS: `arn:aws:eks:us-west-2:account:cluster/name` → `name`
- Azure: `aks_project_eastus_cluster` → `project:cluster`

## Requirements

- tmux 2.1 or higher
- kubectl installed and configured

## Troubleshooting

If the plugin displays "kubectl command not found":

1. Ensure kubectl is installed:
   ```bash
   which kubectl
   ```

2. The plugin automatically sets common PATH locations. If kubectl is in a non-standard location, the plugin script handles this.

## License

MIT

## Author

babarot
