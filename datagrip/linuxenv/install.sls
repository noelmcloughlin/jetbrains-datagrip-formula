# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

datagrip-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/datagrip
    - target: {{ datagrip.pkg.archive.path }}
    - onlyif: test -d '{{ datagrip.pkg.archive.path }}'
    - force: True

        {% if datagrip.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

datagrip-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: datagriphome
    - link: /opt/datagrip
    - path: {{ datagrip.pkg.archive.path }}
    - priority: {{ datagrip.linux.altpriority }}
    - retry: {{ datagrip.retry_option|json }}

datagrip-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: datagriphome
    - path: {{ datagrip.pkg.archive.path }}
    - onchanges:
      - alternatives: datagrip-linuxenv-home-alternatives-install
    - retry: {{ datagrip.retry_option|json }}

datagrip-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: datagrip
    - link: {{ datagrip.linux.symlink }}
    - path: {{ datagrip.pkg.archive.path }}/{{ datagrip.command }}
    - priority: {{ datagrip.linux.altpriority }}
    - require:
      - alternatives: datagrip-linuxenv-home-alternatives-install
      - alternatives: datagrip-linuxenv-home-alternatives-set
    - retry: {{ datagrip.retry_option|json }}

datagrip-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: datagrip
    - path: {{ datagrip.pkg.archive.path }}/{{ datagrip.command }}
    - onchanges:
      - alternatives: datagrip-linuxenv-executable-alternatives-install
    - retry: {{ datagrip.retry_option|json }}

        {%- else %}

datagrip-linuxenv-alternatives-install-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (datagrip.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
