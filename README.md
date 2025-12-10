# tmux-kube-context

![tmux-kube-context in action](image.png)

A tmux plugin that displays the current Kubernetes context and namespace in the status bar.

![](https://img.shields.io/badge/tmux-plugin-blue)

## Features

- Displays current Kubernetes context and namespace
- Automatically updates based on your kubectl configuration
- Customizable colors and formatting
- Strips cloud provider prefixes and region suffixes (GCP, AWS, Azure)
- Hostname-based activation for sharing tmux.conf across multiple machines
- Clean, readable display format with colon separator (project:cluster/namespace)

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
   run '~/.tmux/plugins/tmux-kube-context/kube-context.tmux'
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

### Enabled Hosts

Specify which hosts (by hostname) should enable this plugin. Useful when sharing tmux.conf across multiple machines:

```tmux
set -g @kube-context-enabled-hosts 'work-macbook company-laptop'
```

Default: empty (enabled on all hosts)

When set, the plugin will only activate on hosts whose hostname matches one of the space-separated values. This is particularly useful when:
- You share your tmux configuration between work and personal machines
- kubectl is only installed on specific machines
- You want the Kubernetes context display on work machines but not on personal ones

Example use case:
```tmux
# Only show Kubernetes context on work machines
set -g @kube-context-enabled-hosts 'work-macbook-pro company-desktop'
```

To find your current hostname, run:
```bash
hostname -s
```

### Enabled Directories

Specify which directories should enable this plugin. The plugin will only display when you're working in or under these directories:

```tmux
set -g @kube-context-enabled-dirs '~/src/github.com/work ~/projects/kubernetes'
```

Default: empty (enabled in all directories)

When set, the plugin will only activate when the current working directory is under one of the space-separated directory paths. This is particularly useful when:
- You work on both Kubernetes and non-Kubernetes projects
- You want the context display only in specific project directories
- You share your tmux configuration but work in different project structures

Example use case:
```tmux
# Only show Kubernetes context when working in specific directories
set -g @kube-context-enabled-dirs '~/src/github.com/company ~/work/k8s-projects'
```

**Note:** You can use `~` to represent your home directory. The check includes subdirectories automatically.

### Combining Conditions

Both `@kube-context-enabled-hosts` and `@kube-context-enabled-dirs` can be used together:

```tmux
# Show only on work laptop AND in work directories
set -g @kube-context-enabled-hosts 'work-laptop'
set -g @kube-context-enabled-dirs '~/work'
```

When both are set, **both conditions must be satisfied** for the plugin to display.

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

# Enable only on specific hosts (optional)
set -g @kube-context-enabled-hosts 'work-laptop company-desktop'

# Enable only in specific directories (optional)
set -g @kube-context-enabled-dirs '~/work ~/src/github.com/company'

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
