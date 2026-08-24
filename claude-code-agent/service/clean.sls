# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude__code__agent with context %}

claude-code-agent-service-clean-service-dead:
  service.dead:
    - name: {{ claude__code__agent.service.name }}
    - enable: False
