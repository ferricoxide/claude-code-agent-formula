# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude__code__agent with context %}

claude-code-agent-package-install-pkg-installed:
  pkg.installed:
    - name: {{ claude__code__agent.pkg.name }}
