# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower in ('windows', 'linux', 'darwin',) %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import datagrip with context %}

include:
  - {{ '.macapp' if datagrip.pkg.use_upstream_macapp else '.archive' }}.clean
  - .config.clean
  - .linuxenv.clean

    {%- else %}

datagrip-not-available-to-install:
  test.show_notification:
    - text: |
        The datagrip package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
