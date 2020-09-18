# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

datagrip-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ datagrip.pkg.deps|json }}
    - require_in:
      - file: datagrip-package-archive-install

              {%- if datagrip.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ datagrip.dir.tmp }}/datagrip.exe
    - source: {{ datagrip.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ datagrip.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ datagrip.dir.tmp }}/datagrip.exe
    - require:
      - file: datagrip-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ datagrip.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: datagrip-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ datagrip.identity.rootuser }}
    - group: {{ datagrip.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(datagrip.pkg.archive) }}
    - retry: {{ datagrip.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ datagrip.identity.rootuser }}
    - group: {{ datagrip.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: datagrip-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and datagrip.linux.altpriority|int == 0 %}

datagrip-archive-install-file-symlink-datagrip:
  file.symlink:
    - name: /usr/local/bin/{{ datagrip.command }}
    - target: {{ datagrip.dir.path }}/{{ datagrip.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: datagrip-package-archive-install

              {%- elif datagrip.flavour|lower == 'windowszip' %}

datagrip-archive-install-file-shortcut-datagrip:
  file.shortcut:
    - name: C:\Users\{{ datagrip.identity.rootuser }}\Desktop\{{ datagrip.dirname }}.lnk
    - target: {{ datagrip.dir.archive }}\{{ datagrip.dirname }}\{{ datagrip.command }}
    - working_dir: {{ datagrip.dir.archive }}\{{ datagrip.dirname }}\bin
    - icon_location: {{ datagrip.dir.archive }}\{{ datagrip.dirname }}\bin\datagrip.ico
    - makedirs: True
    - force: True
    - user: {{ datagrip.identity.rootuser }}
    - require:
      - archive: datagrip-package-archive-install

              {%- endif %}
