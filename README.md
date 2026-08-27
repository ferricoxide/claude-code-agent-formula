claude-code-tui-formula
==================

A SaltStack formula designed to install and configure the [Claude Code coding-assistant package](https://code.claude.com/docs/en/overview) on installation-targets.

It is primarily expected that this formula will be run via [P3](https://www.plus3it.com/)'s "[watchmaker](https://watchmaker.readthedocs.io/en/stable/)" framework.

This formula is able to install the Claude Code coding-assistant utility on Linux and Windows Server operating environments. Installation for internet-connected systems may be done using:
* Vendor-provided installation-scripts
* Vendor-provided install-packages (RHEL-based distros only)
* NPM-based install

The Claude Code coding-assistant updates _frequently_. Sites that wish to use a specific version of the Claude Code coding-assistant will need to specifically-target that associated install-content, possibly even to the degree that they will need to self-host it.

Targeting specific versions of the Claude Code coding-assistant or local copies of the install-archives can be directed to do so by adding appropriate content to the formula's associated Pillar-data (see this projct's [pillar.example](pillar.example) file for guidance).


## Available states

- [claude-code-tui](#claude-code-tui)
- [claude-code-tui.clean](#claude-code-tui.clean)
- [claude-code-tui.package](#claude-code-tui.package)
- [claude-code-tui.package.clean](#claude-code-tui.package.clean)
- [claude-code-tui.config](#claude-code-tui.config)
- [claude-code-tui.config.clean](#claude-code-tui.config.clean)

### claude-code-tui

Executes the `package` and `config` states to install and configure the Claude Code coding-assistant

### claude-code-tui.clean

Executes the `package` and `config` states' `clean` actions to fully uninstall the Claude Code coding-assistant and remove previously-installed browser policy-configs (and, on Windows, associated registry entries)

### claude-code-tui.package

Executes _just_ the `package` state to install the Claude Code coding-assistant package.

### claude-code-tui.package.clean

Executes _just_ the `package.clean` state to uninstall the Claude Code coding-assistant package.

### claude-code-tui.config

Executes _just_ the `config` state to install/configure the Claude Code coding-assistant client-configuration (etc.) files

### claude-code-tui.config.clean

Executes _just_ the `config` state to uninstall the Claude Code coding-assistant client-configuration (etc.) files and, on Windows, remove any registry-keys set by prior install-runs of the formula.

## Compatibility Notes:

If selecting the NPM-based installation-method, it is _critical_ that an appropriate version[^1} of the `npm` utility is installed and that the formula is able to locate it.

### Linux

While there RPM packagings of the Claude Code coding-assistant agent available from OpenAI, these packagings typically run behind what gets installed via either the official BASH-based installer script or the NPM repositories.


### Windows

1. As of this README's writing, this project's contents only install the Claude Code coding-assistant agent's TUI interface. The GUI's installer does not function well in the "session 0" scope that this formula operates under. It has, therefore, been omitted from this project.
1. While there are installable packagings of the Claude Code coding-assistant agent available from OpenAI, these packagings do not function well in the "session 0" scope that this formula operates under. Further, these packagings mostly expect to be installed on a per-user basis while the focus of this project is system-wide installation. Therefore, package-based installs are not supported by this project for Windows-based targets.

[^1]: As of this document's writing, the latest-available version of NodeJS is v26.8.0. This fersion is not compatible with SaltStack 3007 currently expected by this formula. It is recommended to use NodeJS v22 LTS: this automation was tested with v22.14.0
