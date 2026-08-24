# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as claude_code_agent
      with context %}

{%- if claude_code_agent.install_method == 'script' %}

Download Claude Code Install Script:
  file.managed:
    - group: {{ claude_code_agent.install_script.group }}
    - mode: '{{ claude_code_agent.install_script.mode }}'
    - name: {{ claude_code_agent.install_script.target }}
    - require:
      - pkg: Install Claude Code Agent OS Dependencies
    - skip_verify: {{ claude_code_agent.install_script.skip_verify }}
    - source: {{ claude_code_agent.install_script.source }}
{%- if claude_code_agent.install_script.source_hash %}
    - source_hash: {{ claude_code_agent.install_script.source_hash }}
{%- endif %}
    - user: {{ claude_code_agent.install_script.user }}

Execute Claude Code Install Script:
  cmd.run:
    - creates: {{ claude_code_agent.install_script.creates }}
    - name: {{ claude_code_agent.install_script.target }}
    - require:
      - file: Download Claude Code Install Script
      - pkg: Install Claude Code Agent OS Dependencies

{%- elif claude_code_agent.install_method == 'npm' %}

Install Claude Code Npm Package:
  npm.installed:
    - name: {{ claude_code_agent.pkg.npm.name }}
    - require:
      - pkg: Install Nodejs Package

Install Nodejs Package:
  pkg.installed:
    - name: {{ claude_code_agent.pkg.nodejs.name }}
    - require:
      - pkg: Install Claude Code Agent OS Dependencies

{%- elif claude_code_agent.install_method == 'rpm' %}

Emit The Not Supported Message:
  test.fail_without_changes:
    - name: 'RPM-based installation not yet supported'
{%- endif %}

Install Claude Code Agent OS Dependencies:
  pkg.installed:
    - pkgs: {{ claude_code_agent.pkg.deps | json }}
