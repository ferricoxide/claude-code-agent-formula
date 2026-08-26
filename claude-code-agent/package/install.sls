# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent with context %}

include:
{%- if grains.kernel == "Linux" %}
  - claude-code-agent.package.lin_install
{%- elif grains.kernel == "Windows" %}
  - claude-code-agent.package.win_install
{%- endif %}

Avoid being a null-router (package/install) - Claude Code Agent:
  test.nop: []
