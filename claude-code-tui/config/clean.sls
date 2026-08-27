# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_tui with context %}

include:
{%- if grains.kernel == "Linux" %}
  - claude-code-tui.config.lin_clean
{%- elif grains.kernel == "Windows" %}
  - claude-code-tui.config.win_clean
{%- endif %}

Avoid being a null-router (config/clean) - Claude Code Agent:
  test.nop: []
