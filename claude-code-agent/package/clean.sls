# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent with context %}

include:
  - {{ sls_config_clean }}
{%- if grains.kernel == "Linux" %}
  - claude-code-agent.package.lin_clean
{%- elif grains.kernel == "Windows" %}
  - claude-code-agent.package.win_clean
{%- endif %}

Avoid being a null-router (package/clean) - Claude Code Agent:
  test.nop: []
