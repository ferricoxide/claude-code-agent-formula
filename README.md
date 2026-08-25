claude-code-agent-formula
==================

A SaltStack formula designed to install and configure the [Claude Code coding-assistant package](https://code.claude.com/docs/en/overview) on installation-targets.

It is primarily expected that this formula will be run via [P3](https://www.plus3it.com/)'s "[watchmaker](https://watchmaker.readthedocs.io/en/stable/)" framework.

This formula is able to install the Claude Code coding-assistant utility on Linux and Windows Server operating environments. Installation for internet-connected systems may be done using:
* Vendor-provided installation-scripts
* Vendor-provided install-packages
* NPM-based install

The Claude Code coding-assistant updates _frequently_. Sites that wish to use a specific version of the Claude Code coding-assistant will need to specifically-target that associated install-content, possibly even to the degree that they will need to self-host it.

Targeting specific versions of the Claude Code coding-assistant or local copies of the install-archives can be directed to do so by adding appropriate content to the formula's associated Pillar-data (see this projct's [pillar.example](pillar.example) file for guidance).


## Available states

- [claude-code-agent](#claude-code-agent)
- [claude-code-agent.clean](#claude-code-agent.clean)
- [claude-code-agent.package](#claude-code-agent.package)
- [claude-code-agent.package.clean](#claude-code-agent.package.clean)
- [claude-code-agent.config](#claude-code-agent.config)
- [claude-code-agent.config.clean](#claude-code-agent.config.clean)

### claude-code-agent

Executes the `package` and `config` states to install and configure the Claude Code coding-assistant

### claude-code-agent.clean

Executes the `package` and `config` states' `clean` actions to fully uninstall the Claude Code coding-assistant and remove previously-installed browser policy-configs (and, on Windows, associated registry entries)

### claude-code-agent.package

Executes _just_ the `package` state to install the Claude Code coding-assistant package.

### claude-code-agent.package.clean

Executes _just_ the `package.clean` state to uninstall the Claude Code coding-assistant package.

### claude-code-agent.config

Executes _just_ the `config` state to install/configure the Claude Code coding-assistant client-configuration (etc.) files

### claude-code-agent.config.clean

Executes _just_ the `config` state to uninstall the Claude Code coding-assistant client-configuration (etc.) files and, on Windows, remove any registry-keys set by prior install-runs of the formula.

## Compatibility Notes:

### Linux


### Windows
