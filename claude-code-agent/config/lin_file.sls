# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}

{%- set cfg = claude_code_agent.get('config', {}) %}
{%- set root_dir = cfg.get('root_dir', '/etc/claude-code') %}

{%- if cfg %}

Manage Claude Code Configuration Directory:
  file.directory:
    - group: root
    - mode: '0755'
    - name: {{ root_dir }}
    - user: root

  {%- for file_relpath, file_content in cfg.items() %}
    {%- if file_relpath != 'root_dir' %}

Manage Claude Code Configuration File {{ file_relpath }}:
  file.managed:
    - contents: {{ file_content | json }}
    - group: root
    - makedirs: True
    - mode: '0644'
    - name: {{ root_dir }}/{{ file_relpath }}
    - require:
      - file: Manage Claude Code Configuration Directory
      - sls: {{ sls_package_install }}
    - user: root

    {%- endif %}
  {%- endfor %}
{%- endif %}
