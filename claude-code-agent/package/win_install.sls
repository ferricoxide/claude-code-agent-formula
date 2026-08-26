# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}
{%- if claude_code_agent.install_method == 'script' %}
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
        "{{ script_cfg.target }}"
    - require:
      - file: Download Claude Code Install Script
    - shell: powershell
{%- endif %}
