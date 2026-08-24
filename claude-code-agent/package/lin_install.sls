# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}

{%- if claude_code_agent.install_method == 'script' %}
{%-   set paths = claude_code_agent.path %}
{%-   set script_cfg = claude_code_agent.install_script %}

Download Claude Code Install Script:
  file.managed:
    - group: {{ script_cfg.group }}
    - mode: '{{ script_cfg.mode }}'
    - name: {{ script_cfg.target }}
    - require:
      - pkg: Install Claude Code Agent OS Dependencies
    - skip_verify: {{ script_cfg.get('skip_verify', True) }}
    - source: {{ script_cfg.source }}
{%- if script_cfg.source_hash %}
    - source_hash: {{ script_cfg.source_hash }}
{%- endif %}
    - user: {{ script_cfg.user }}

Execute Claude Code Install Script:
  cmd.run:
    - creates: {{ script_cfg.creates }}
{%- if script_cfg.get('env') %}
    - env: {{ script_cfg.env | json }}
{%- endif %}
    - name: {{ script_cfg.target }}
    - require:
      - file: Download Claude Code Install Script
      - pkg: Install Claude Code Agent OS Dependencies

Relocate Claude Code To Global Location:
  cmd.run:
    - name: |
        REAL_BIN=$(readlink -f {{ paths.root_bin }})
        TARGET_DIR={{ paths.global_share }}
        rm -rf "$TARGET_DIR"
        mv {{ paths.root_share }} "$TARGET_DIR"
        chmod -R 0755 "$TARGET_DIR"
        REL_PATH="${REAL_BIN#/root/.local/share/claude/}"
        ln -sf "$TARGET_DIR/$REL_PATH" {{ paths.global_bin }}
        rm -f {{ paths.root_bin }}
    - onchanges:
      - cmd: Execute Claude Code Install Script
    - require:
      - cmd: Execute Claude Code Install Script

{%- elif claude_code_agent.install_method == 'npm' %}

Install Claude Code Npm Package:
  npm.installed:
    - name: {{ claude_code_agent.pkg.npm.name }}
    - require:
      - pkg: Install Nodejs Package

Install Nodejs Package:
  pkg.installed:
    - name: {{ claude_code_agent.pkg.nodejs.name }}
    - require:
      - pkg: Install Claude Code Agent OS Dependencies

{%- elif claude_code_agent.install_method == 'rpm' %}
{%-   set repo_cfg = claude_code_agent.repo %}

Configure Claude Code Repository:
  pkgrepo.managed:
    - baseurl: {{ repo_cfg.baseurl }}
    - enabled: {{ repo_cfg.enabled }}
    - file: {{ repo_cfg.file }}
    - gpgcheck: {{ repo_cfg.gpgcheck }}
    - gpgkey: {{ repo_cfg.gpgkey }}
    - humanname: {{ repo_cfg.humanname }}
    - name: {{ repo_cfg.name }}

Install Claude Code Rpm Package:
  pkg.installed:
    - name: {{ claude_code_agent.pkg.rpm.name }}
    - require:
      - pkgrepo: Configure Claude Code Repository

{%- endif %}

Install Claude Code Agent OS Dependencies:
  pkg.installed:
    - pkgs: {{ claude_code_agent.pkg.deps | json }}
