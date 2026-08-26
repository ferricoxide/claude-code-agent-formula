# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}

{%- if claude_code_agent.install_method == 'script' %}
  {%- set paths = claude_code_agent.path %}
  {%- set script_cfg = claude_code_agent.install_script %}

Download Claude Code Install Script:
  file.managed:
    - makedirs: true
    - name: '{{ script_cfg.target }}'
    - skip_verify: {{ script_cfg.get('skip_verify', True) }}
    - source: '{{ script_cfg.source }}'

Execute Claude Code Install Script:
  cmd.run:
    - creates: '{{ script_cfg.creates }}'
{%- if script_cfg.get('env') %}
    - env: {{ script_cfg.env | json }}
{%- endif %}
    - name: >-
        powershell -ExecutionPolicy Bypass -File
        "C:\Windows\Temp\install_claude_helper.ps1"
        -InstallScriptPath "{{ script_cfg.target }}"
        -InstallRoot "{{ paths.global_share }}"
    - require:
      - file: Download Claude Code Install Script
      - file: Stage Claude Code Helper Script
    - shell: powershell

Stage Claude Code Helper Script:
  file.managed:
    - makedirs: true
    - name: 'C:\Windows\Temp\install_claude_helper.ps1'
    - source: salt://claude-code-agent/files/install_claude_helper.ps1
{%- elif claude_code_agent.install_method == 'npm' %}
Verify NPM Executable Presence:
  cmd.run:
    - name: |
        $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
        if (-not (Get-Command npm -ErrorAction SilentlyContinue) -and -not (Test-Path "C:\Program Files\nodejs\npm.cmd")) {
            Write-Error "NPM executable not found in PATH or standard Node.js directory. Ensure Node.js/NPM is pre-installed."
            exit 1
        }
    - shell: powershell

Install Claude Code Npm Package:
  npm.installed:
    - name: '{{ claude_code_agent.pkg.npm.name }}'
    - require:
      - cmd: Verify NPM Executable Presence
{%- endif %}
