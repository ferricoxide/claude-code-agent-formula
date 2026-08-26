# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package = tplroot ~ '.package' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}
{%- set cfg = claude_code_agent.get('config', {}) %}
{%- set root_dir = cfg.get('root_dir', 'C:\ProgramData\claude-code') %}
{%- set start_dir = 'C:\ProgramData\Microsoft\Windows\Start Menu' %}
{%- set start_lnk = start_dir ~ '\Programs\Claude Code.lnk' %}
include:
  - {{ sls_package }}

Configure Claude Code Desktop Shortcut:
  shortcut.present:
    - arguments: ''
    - icon_index: 0
    - icon_location: '{{ claude_code_agent.path.global_bin }}'
    - name: 'C:\Users\Public\Desktop\Claude Code.lnk'
    - target: '{{ claude_code_agent.path.global_bin }}'
    - working_dir: '{{ claude_code_agent.path.global_share }}'

Configure Claude Code System Path:
  win_path.exists:
    - name: '{{ claude_code_agent.path.global_share }}'

Configure Start Menu Shortcut:
  shortcut.present:
    - arguments: ''
    - icon_index: 0
    - icon_location: '{{ claude_code_agent.path.global_bin }}'
    - name: '{{ start_lnk }}'
    - target: '{{ claude_code_agent.path.global_bin }}'
    - working_dir: '{{ claude_code_agent.path.global_share }}'

Harden Claude Code Directory Permissions:
  file.directory:
    - name: '{{ claude_code_agent.path.global_share }}'
    - win_inheritance: true
    - win_owner: 'BUILTIN\Administrators'
    - win_perms:
        BUILTIN\Administrators:
          perms: full_control
        BUILTIN\Users:
          perms: read_execute

Manage Claude Code Configuration Directory:
  file.directory:
    - name: '{{ root_dir }}'
    - win_inheritance: true
    - win_owner: 'BUILTIN\Administrators'
    - win_perms:
        BUILTIN\Administrators:
          perms: full_control
        BUILTIN\Users:
          perms: read_execute
{%- for file_relpath, file_content in cfg.items() | sort %}
  {%- if file_relpath != 'root_dir' %}

Manage Claude Code Configuration File {{ file_relpath }}:
  file.managed:
    - contents: {{ file_content | json }}
    - makedirs: true
    - name: '{{ root_dir }}\{{ file_relpath }}'
    - require:
      - file: Manage Claude Code Configuration Directory
    - win_owner: 'BUILTIN\Administrators'
  {%- endif %}
{%- endfor %}
