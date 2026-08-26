# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package = tplroot ~ '.package' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent with context %}
{%- set cfg = claude_code_agent.get('config', {}) %}
{%- set root_dir = cfg.get('root_dir', 'C:\ProgramData\claude-code') %}
{%- set start_dir = 'C:\ProgramData\Microsoft\Windows\Start Menu' %}
{%- set start_lnk = start_dir ~ '\Programs\Claude Code.lnk' %}

{#- Resolve target binary and working directory paths for shortcuts #}
{%- set ns = namespace(bin_target=None, bin_dir=None) %}
{%- if claude_code_agent.install_method == 'script' %}
  {%- set ns.bin_target = claude_code_agent.path.global_bin %}
  {%- set ns.bin_dir = claude_code_agent.path.global_share %}
{%- elif claude_code_agent.install_method == 'npm' %}
  {%- set ns.bin_target = 'C:\Program Files\nodejs\claude.cmd' %}
  {%- set ns.bin_dir = 'C:\Program Files\nodejs' %}
{%- endif %}

include:
  - {{ sls_package }}

{%- if claude_code_agent.install_method == 'script' %}
Configure Claude Code System Path:
  win_path.exists:
    - name: '{{ ns.bin_dir }}'

Harden Claude Code Directory Permissions:
  file.directory:
    - name: '{{ ns.bin_dir }}'
    - win_inheritance: true
    - win_owner: 'BUILTIN\Administrators'
    - win_perms:
        BUILTIN\Administrators:
          perms: full_control
        BUILTIN\Users:
          perms: read_execute
{%- endif %}

{%- if ns.bin_target %}
Configure Claude Code Desktop Shortcut:
  shortcut.present:
    - arguments: ''
    - icon_index: 0
    - icon_location: '{{ ns.bin_target }}'
    - name: 'C:\Users\Public\Desktop\Claude Code.lnk'
    - target: '{{ ns.bin_target }}'
    - working_dir: '{{ ns.bin_dir }}'

Configure Start Menu Shortcut:
  shortcut.present:
    - arguments: ''
    - icon_index: 0
    - icon_location: '{{ ns.bin_target }}'
    - name: '{{ start_lnk }}'
    - target: '{{ ns.bin_target }}'
    - working_dir: '{{ ns.bin_dir }}'
{%- endif %}

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
