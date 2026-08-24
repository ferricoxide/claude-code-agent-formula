# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude__code__agent with context %}

include:
  - {{ sls_service_clean }}

claude-code-agent-config-clean-file-absent:
  file.absent:
    - name: {{ claude__code__agent.config }}
    - require:
      - sls: {{ sls_service_clean }}
