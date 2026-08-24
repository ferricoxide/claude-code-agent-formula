# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude__code__agent with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

claude-code-agent-config-file-file-managed:
  file.managed:
    - name: {{ claude__code__agent.config }}
    - source: {{ files_switch(['example.tmpl'],
                              lookup='claude-code-agent-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ claude__code__agent.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        claude__code__agent: {{ claude__code__agent | json }}
