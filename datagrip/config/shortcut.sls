# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if datagrip.linux.install_desktop_file and grains.os not in ('MacOS',) %}
       {%- if datagrip.pkg.use_upstream_macapp %}
           {%- set sls_package_install = tplroot ~ '.macapp.install' %}
       {%- else %}
           {%- set sls_package_install = tplroot ~ '.archive.install' %}
       {%- endif %}

include:
  - {{ sls_package_install }}

datagrip-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ datagrip.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='datagrip-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ datagrip.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
        appname: {{ datagrip.pkg.name }}
        edition: {{ datagrip.edition|json }}
        command: {{ datagrip.command|json }}
              {%- if datagrip.pkg.use_upstream_macapp %}
        path: {{ datagrip.pkg.macapp.path }}
    - onlyif: test -f "{{ datagrip.pkg.macapp.path }}/{{ datagrip.command }}"
              {%- else %}
        path: {{ datagrip.pkg.archive.path }}
    - onlyif: test -f {{ datagrip.pkg.archive.path }}/{{ datagrip.command }}
              {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
