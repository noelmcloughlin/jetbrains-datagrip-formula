{% from "datagrip/map.jinja" import datagrip with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

datagrip-home-symlink:
  file.symlink:
    - name: '{{ datagrip.jetbrains.home }}/datagrip'
    - target: '{{ datagrip.jetbrains.realhome }}'
    - onlyif: test -d {{ datagrip.jetbrains.realhome }}
    - force: True

# Update system profile with PATH
datagrip-config:
  file.managed:
    - name: /etc/profile.d/datagrip.sh
    - source: salt://datagrip/files/datagrip.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ datagrip.jetbrains.home|json }}/datagrip'

  # Linux alternatives
  {% if datagrip.linux.altpriority > 0 and grains.os_family not in ('Arch',) %}

# Add datagriphome to alternatives system
datagrip-home-alt-install:
  alternatives.install:
    - name: datagrip-home
    - link: '{{ datagrip.jetbrains.home }}/datagrip'
    - path: '{{ datagrip.jetbrains.realhome }}'
    - priority: {{ datagrip.linux.altpriority }}

datagrip-home-alt-set:
  alternatives.set:
    - name: datagrip-home
    - path: {{ datagrip.jetbrains.realhome }}
    - onchanges:
      - alternatives: datagrip-home-alt-install

# Add to alternatives system
datagrip-alt-install:
  alternatives.install:
    - name: datagrip
    - link: {{ datagrip.linux.symlink }}
    - path: {{ datagrip.jetbrains.realcmd }}
    - priority: {{ datagrip.linux.altpriority }}
    - require:
      - alternatives: datagrip-home-alt-install
      - alternatives: datagrip-home-alt-set

datagrip-alt-set:
  alternatives.set:
    - name: datagrip
    - path: {{ datagrip.jetbrains.realcmd }}
    - onchanges:
      - alternatives: datagrip-alt-install

  {% endif %}

  {% if datagrip.linux.install_desktop_file %}
datagrip-global-desktop-file:
  file.managed:
    - name: {{ datagrip.linux.desktop_file }}
    - source: salt://datagrip/files/datagrip.desktop
    - template: jinja
    - context:
      home: {{ datagrip.jetbrains.realhome|json }}
      command: {{ datagrip.command|json }}
      edition: {{ datagrip.jetbrains.edition|json }}
    - onlyif: test -f {{ datagrip.jetbrains.realhome }}/{{ datagrip.command }}
  {% endif %}

{% endif %}
