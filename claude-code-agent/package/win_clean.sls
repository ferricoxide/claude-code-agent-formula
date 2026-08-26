# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}

Remove Claude Code Global Share Directory:
  file.absent:
    - name: '{{ claude_code_agent.path.global_share }}'

Remove Claude Code Staged Helper Script:
  file.absent:
    - name: 'C:\Windows\Temp\install_claude_helper.ps1'

Remove Claude Code Staged Installer Script:
  file.absent:
    - name: '{{ claude_code_agent.install_script.target }}'
