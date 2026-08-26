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
        "{{ script_cfg.target }}";
        $sys_bin = "$env:SystemRoot\System32\config\" +
        "systemprofile\.local\bin\claude.exe";
        $sys_share = "$env:SystemRoot\System32\config\" +
        "systemprofile\.local\share\claude";
        $target_dir = '{{ paths.global_share }}';
        if (Test-Path $sys_bin) {
          if (-not (Test-Path $target_dir)) {
            New-Item -ItemType Directory -Force
            -Path $target_dir | Out-Null;
          }
          Copy-Item -Path "$sys_bin"
          -Destination "$target_dir\claude.exe" -Force;
          if (Test-Path $sys_share) {
            Copy-Item -Path "$sys_share"
            -Destination "$target_dir\share"
            -Recurse -Force;
          }
        }
    - require:
      - file: Download Claude Code Install Script
    - shell: powershell
{%- endif %}
