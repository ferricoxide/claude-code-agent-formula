# -*- coding: utf-8 -*-
# vim: ft=sls
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}
{%- set cfg = claude_code_agent.get('config', {}) %}
{%- set root_dir = cfg.get('root_dir', 'C:\ProgramData\claude-code') %}
{%- set start_dir = 'C:\ProgramData\Microsoft\Windows\Start Menu' %}
{%- set start_lnk = start_dir ~ '\Programs\Claude Code.lnk' %}
{%- if cfg %}

Remove Claude Code Configuration Directory:
  file.absent:
    - name: '{{ root_dir }}'
{%- endif %}

Remove Claude Code Desktop Shortcut:
  file.absent:
    - name: 'C:\Users\Public\Desktop\Claude Code.lnk'

Remove Claude Code Start Menu Shortcut:
  file.absent:
    - name: '{{ start_lnk }}'

Remove Claude Code System Path:
  win_path.absent:
    - name: '{{ claude_code_agent.path.global_share }}'
