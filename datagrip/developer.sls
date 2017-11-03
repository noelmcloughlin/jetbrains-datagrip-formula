{% from "datagrip/map.jinja" import datagrip with context %}

{% if datagrip.prefs.user not in (None, 'undefined_user', 'undefined', '',) %}

  {% if grains.os == 'MacOS' %}
datagrip-desktop-shortcut-clean:
  file.absent:
    - name: '{{ datagrip.homes }}/{{ datagrip.prefs.user }}/Desktop/DataGrip'
    - require_in:
      - file: datagrip-desktop-shortcut-add
  {% endif %}

datagrip-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://datagrip/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ datagrip.prefs.user }}
      homes: {{ datagrip.homes }}
      edition: {{ datagrip.jetbrains.edition }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ datagrip.jetbrains.edition }}
    - runas: {{ datagrip.prefs.user }}
    - require:
      - file: datagrip-desktop-shortcut-add
   {% else %}
   #Linux
  file.managed:
    - source: salt://datagrip/files/datagrip.desktop
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/Desktop/datagrip{{ datagrip.jetbrains.edition }}.desktop
    - user: {{ datagrip.prefs.user }}
    - makedirs: True
      {% if grains.os_family in ('Suse',) %} 
    - group: users
      {% else %}
    - group: {{ datagrip.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ datagrip.jetbrains.realcmd }}
    - context:
      home: {{ datagrip.jetbrains.realhome }}
      command: {{ datagrip.command }}
   {% endif %}


  {% if datagrip.prefs.xmlurl or datagrip.prefs.xmldir %}

datagrip-prefs-importfile:
   {% if datagrip.prefs.xmldir %}
  file.managed:
    - onlyif: test -f {{ datagrip.prefs.xmldir }}/{{ datagrip.prefs.xmlfile }}
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
    - source: {{ datagrip.prefs.xmldir }}/{{ datagrip.prefs.xmlfile }}
    - user: {{ datagrip.prefs.user }}
    - makedirs: True
        {% if grains.os_family in ('Suse',) %}
    - group: users
        {% elif grains.os not in ('MacOS',) %}
        #inherit Darwin ownership
    - group: {{ datagrip.prefs.user }}
        {% endif %}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{datagrip.homes}}/{{datagrip.prefs.user}}/{{datagrip.prefs.xmlfile}} {{datagrip.prefs.xmlurl}}
    - runas: {{ datagrip.prefs.user }}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.xmlfile }}
   {% endif %}

  {% endif %}

{% endif %}

