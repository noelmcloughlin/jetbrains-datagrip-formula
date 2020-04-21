# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

datagrip-package-archive-install:
  pkg.installed:
    - names: {{ datagrip.pkg.deps|json }}
    - require_in:
      - file: datagrip-package-archive-install
  file.directory:
    - name: {{ datagrip.pkg.archive.path }}
    - user: {{ datagrip.identity.rootuser }}
    - group: {{ datagrip.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: datagrip-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(datagrip.pkg.archive) }}
    - retry: {{ datagrip.retry_option|json }}
    - user: {{ datagrip.identity.rootuser }}
    - group: {{ datagrip.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: datagrip-package-archive-install

    {%- if datagrip.linux.altpriority|int == 0 %}

datagrip-archive-install-file-symlink-datagrip:
  file.symlink:
    - name: /usr/local/bin/datagrip
    - target: {{ datagrip.pkg.archive.path }}/{{ datagrip.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: datagrip-package-archive-install

    {%- endif %}
