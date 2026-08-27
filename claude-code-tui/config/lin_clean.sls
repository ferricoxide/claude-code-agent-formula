# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_tui
      with context %}

{%- set cfg = claude_code_tui.get('config', {}) %}
{%- set root_dir = cfg.get('root_dir', '/etc/claude-code') %}

{%- if cfg %}

Remove Claude Code Configuration Directory:
  file.absent:
    - name: {{ root_dir }}

{%- endif %}
