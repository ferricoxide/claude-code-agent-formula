# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_tui with context %}

include:
{%- if grains.kernel == "Linux" %}
  - claude-code-tui.package.lin_install
{%- elif grains.kernel == "Windows" %}
  - claude-code-tui.package.win_install
{%- endif %}

Avoid being a null-router (package/install) - Claude Code Agent:
  test.nop: []
