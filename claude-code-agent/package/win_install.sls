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
{%- endif %}
