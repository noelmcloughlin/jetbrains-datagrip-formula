{% from "datagrip/map.jinja" import datagrip with context %}

{% if datagrip.prefs.user %}

datagrip-desktop-shortcut-clean:
  file.absent:
    - name: '{{ datagrip.homes }}/{{ datagrip.prefs.user }}/Desktop/DataGrip'
    - require_in:
      - file: datagrip-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

datagrip-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://datagrip/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ datagrip.prefs.user }}
      homes: {{ datagrip.homes }}
      edition: {{ datagrip.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ datagrip.jetbrains.edition }}
    - runas: {{ datagrip.prefs.user }}
    - require:
      - file: datagrip-desktop-shortcut-add
    - require_in:
      - file: datagrip-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

datagrip-desktop-shortcut-install:
  file.managed:
    - source: salt://datagrip/files/datagrip.desktop
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/Desktop/datagrip{{ datagrip.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ datagrip.prefs.user }}
       {% if datagrip.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ datagrip.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ datagrip.jetbrains.realcmd }}
    - context:
      home: {{ datagrip.jetbrains.realhome }}
      command: {{ datagrip.command }}


  {% if datagrip.prefs.xmlurl or datagrip.prefs.xmldir %}

datagrip-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ datagrip.prefs.xmldir }}/{{ datagrip.prefs.xmlfile }}
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
    - source: {{ datagrip.prefs.xmldir }}/{{ datagrip.prefs.xmlfile }}
    - makedirs: True
    - user: {{ datagrip.prefs.user }}
       {% if datagrip.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ datagrip.prefs.group }}
       {% endif %}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
  cmd.run:
    - unless: test -f {{ datagrip.prefs.xmldir }}/{{ datagrip.prefs.xmlfile }}
    - name: curl -o {{datagrip.homes}}/{{datagrip.prefs.user}}/{{datagrip.prefs.xmlfile}} {{datagrip.prefs.xmlurl}}
    - runas: {{ datagrip.prefs.user }}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
  {% endif %}


{% endif %}

