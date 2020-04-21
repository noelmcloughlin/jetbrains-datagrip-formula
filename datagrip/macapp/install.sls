# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

datagrip-macos-app-install-curl:
  file.directory:
    - name: {{ datagrip.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ datagrip.dir.tmp }}/datagrip-{{ datagrip.version }} {{ datagrip.pkg.macapp.source }}
    - unless: test -f {{ datagrip.dir.tmp }}/datagrip-{{ datagrip.version }}
    - require:
      - file: datagrip-macos-app-install-curl
      - pkg: datagrip-macos-app-install-curl
    - retry: {{ datagrip.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
datagrip-macos-app-install-checksum:
  module.run:
    - onlyif: {{ datagrip.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ datagrip.dir.tmp }}/datagrip-{{ datagrip.version }}
    - file_hash: {{ datagrip.pkg.macapp.source_hash }}
    - require:
      - cmd: datagrip-macos-app-install-curl
    - require_in:
      - macpackage: datagrip-macos-app-install-macpackage
  file.absent:
    - name: {{ datagrip.dir.tmp }}/datagrip-{{ datagrip.version }}
    - onfail:
      - module: datagrip-macos-app-install-checksum

datagrip-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ datagrip.dir.tmp }}/datagrip-{{ datagrip.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: datagrip-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://datagrip/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      appname: {{ datagrip.pkg.name }}
      edition: {{ datagrip.edition }}
      user: {{ datagrip.identity.user }}
      homes: {{ datagrip.dir.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ datagrip.identity.user }}
    - require:
      - file: datagrip-macos-app-install-macpackage

    {%- else %}

datagrip-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The datagrip macpackage is only available on MacOS

    {%- endif %}
