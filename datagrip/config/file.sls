# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in datagrip and datagrip.config and datagrip.config_file %}
    {%- if datagrip.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

datagrip-config-file-managed-config_file:
  file.managed:
    - name: {{ datagrip.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='datagrip-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ datagrip.identity.rootuser }}
    - group: {{ datagrip.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
              {%- if datagrip.pkg.use_upstream_macapp %}
        path: {{ datagrip.pkg.macapp.path }}
              {%- else %}
        path: {{ datagrip.pkg.archive.path }}
              {%- endif %}
        config: {{ datagrip.config|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
