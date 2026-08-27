# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_tui
      with context %}

{%- if claude_code_tui.install_method == 'script' %}
  {%- set paths = claude_code_tui.path %}
  {%- set script_cfg = claude_code_tui.install_script %}

Remove Claude Code Downloaded Script File:
  file.absent:
    - name: '{{ script_cfg.target }}'

Remove Claude Code Global Binary Symlink:
  file.absent:
    - name: '{{ paths.global_bin }}'

Remove Claude Code Global Share Directory:
  file.absent:
    - name: '{{ paths.global_share }}'

{%- elif claude_code_tui.install_method == 'npm' %}

Remove Claude Code Npm Package:
  npm.removed:
    - name: '{{ claude_code_tui.pkg.npm.name }}'

{%- elif claude_code_tui.install_method == 'rpm' %}
  {%- set repo_cfg = claude_code_tui.repo %}

  {%- if claude_code_tui.get('manage_repo', True) %}

Remove Claude Code Repository:
  pkgrepo.absent:
    - file: '{{ repo_cfg.file }}'
    - name: '{{ repo_cfg.name }}'

  {%- endif %}

Remove Claude Code Rpm Package:
  pkg.removed:
    - name: '{{ claude_code_tui.pkg.rpm.name }}'
  {%- if claude_code_tui.get('manage_repo', True) %}
    - require_in:
      - pkgrepo: Remove Claude Code Repository
  {%- endif %}

{%- endif %}
