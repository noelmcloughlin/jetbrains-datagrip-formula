# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

datagrip-macos-app-clean-files:
  file.absent:
    - names:
      - {{ datagrip.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ datagrip.dir.path }}/{{ datagrip.pkg.name }}*{{ datagrip.edition }}*.app
                  {%- else %}
      - {{ datagrip.dir.path }}
                  {%- endif %}

    {%- else %}

datagrip-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The datagrip macpackage is only available on MacOS

    {%- endif %}
