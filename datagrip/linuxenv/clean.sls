# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

datagrip-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/datagrip
      - {{ datagrip.dir.path }}

        {% if datagrip.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

datagrip-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: datagriphome
    - path: {{ datagrip.dir.path }}
    - onlyif: update-alternatives --get-selections |grep ^datagriphome


datagrip-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: datagrip
    - path: {{ datagrip.dir.path }}/{{ datagrip.command }}
    - onlyif: update-alternatives --get-selections |grep ^datagrip

        {%- else %}

datagrip-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (datagrip.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
