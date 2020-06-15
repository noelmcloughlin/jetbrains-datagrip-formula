# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

datagrip-macos-app-clean-files:
  file.absent:
    - names:
      - {{ datagrip.dir.tmp }}
      - /Applications/{{ datagrip.pkg.name }}{{ '' if 'edition' not in datagrip else '\ %sE'|format(datagrip.edition) }}.app   # noqa 204

    {%- else %}

datagrip-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The datagrip macpackage is only available on MacOS

    {%- endif %}
