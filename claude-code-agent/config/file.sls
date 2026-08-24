# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}
{%- if grains.kernel == "Linux" %}
  - claude-code-agent.config.lin_file
{%- elif grains.kernel == "Windows" %}
  - claude-code-agent.config.win_file
  {%- if enforce_hardening %}
  - claude-code-agent.config.win_harden
  {%- endif %}
{%- endif %}

Avoid Being A Null Router Config File:
  test.nop: []
