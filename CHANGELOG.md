## claude-code-agent-formula

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 0.1.1

**Released**: 2026.08.26

*   Added Windows operating environment functionality
    *   Supports dual installation methods (`install_method: script` and `install_method: npm`):
        *   `script`: Installs via native installer (`install.ps1`) and helper staging script (`install_claude_helper.ps1`) to `C:\Program Files\Claude Code`.
        *   `npm`: Installs global package `@anthropic-ai/claude-code` via Node.js/NPM. Includes a pre-flight execution check for `npm.cmd`.
    *   Configures system environment and shell integration:
        *   Dynamically maps Public Desktop and Start Menu shortcuts (`Claude Code.lnk`) based on selected installation method (`claude.exe` vs `claude.cmd`).
        *   Manages system `PATH` and ACL hardening (`BUILTIN\Users` read/execute) for script installs.
    *   Installs the Claude Code coding-agent configuration files under `C:\ProgramData\claude-code\managed-settings.json` and `C:\ProgramData\claude-code\managed-settings.d`.
    *   Implements Windows cleanup states (`win_clean.sls`) to cleanly remove shortcuts, package registrations, binary directories, and configuration trees.

### 0.1.0

**Released**: 2026.08.25

*   Added ("Enterprise") Linux functionality
    *   Installs the Claude Code coding-agent binaries.
        *   `npm` method installs binaries to `/usr/local/bin`
        *   `rpm` method installs binaries to `/usr/bin`
        *   `script` method installs binaries to `/usr/local/bin`
        Note: Installed version for `npm` and `script` methods typically run a few point-releases ahead of the version installed using the `rpm` method
    *   Installs the Claude Code coding-agent configuration-files. Default config-file location is `/etc/claude-code/managed-settings.json`. Config-file location, contents and  whether to use a consolidated config-file or individual files in (`/etc/claude-code.d`) are Pillar-selectable.
    *   Implements "cleanup" for all of the preceeding
*   Adds pillar.example to explain parameters/inputs that may be specified via Pillar

### 0.0.1

**Released**: 2026.08.24

**Summary**:

*   Cloned project from https://github.com/plus3it/repo-template
*   Created claude-code-agent directory-tree contents by:
    1.   Cloning https://github.com/saltstack-formulas/template-formula.git
    2.   Executing `bin/convert-formula.sh claude-code-agent` in the new repo-copy
    3.   Moving the resulting `claude-code-agent` directory into this project's space
    4.   Updating all imports from "`claude__code__agent`" to "`claude_code_agent`"
*   Update [LICENSE](LICENSE), CHANGELOG.md (this file), [README.md](README.md) and [.bumpversion.cfg](.bumpversion.cfg) per the P3 repo-template guidance
*   Update the `.github` and `tests` directories' contents  per the P3 repo-template guidance

