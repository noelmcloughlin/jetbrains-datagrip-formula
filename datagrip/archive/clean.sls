# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

datagrip-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ datagrip.pkg.archive.path }}
      - /usr/local/jetbrains/datagrip-{{ datagrip.edition }}-*
