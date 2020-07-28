# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

d-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ datagrip.dir.tmp }}
             {%- if grains.os == 'MacOS' %}
      - {{ datagrip.dir.path }}/{{ datagrip.pkg.name }}*{{ datagrip.edition }}*.app
             {%- else %}
      - {{ datagrip.dir.path }}
             {%- endif %}
