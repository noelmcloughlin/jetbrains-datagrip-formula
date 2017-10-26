{% from "datagrip/map.jinja" import datagrip with context %}

{% if datagrip.prefs.user not in (None, 'undefined_user') %}

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
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ datagrip.jetbrains.edition }}
    - runas: {{ datagrip.prefs.user }}
    - require:
      - file: datagrip-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://datagrip/files/datagrip.desktop
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/Desktop/datagrip.desktop
    - user: {{ datagrip.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ datagrip.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ datagrip.symhome }}/{{ datagrip.command }}
    - context:
      home: {{ datagrip.symhome }}
      command: {{ datagrip.command }}
   {% endif %}


  {% if datagrip.prefs.importurl or datagrip.prefs.importdir %}

datagrip-prefs-importfile:
   {% if datagrip.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ datagrip.prefs.importdir }}/{{ datagrip.prefs.myfile }}
    - name: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.myfile }}
    - source: {{ datagrip.prefs.importdir }}/{{ datagrip.prefs.myfile }}
    - user: {{ datagrip.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ datagrip.prefs.user }}
        {% endif %}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.myfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{datagrip.homes}}/{{datagrip.prefs.user}}/{{datagrip.prefs.myfile}} {{datagrip.prefs.importurl}}
    - runas: {{ datagrip.prefs.user }}
    - if_missing: {{ datagrip.homes }}/{{ datagrip.prefs.user }}/{{ datagrip.prefs.myfile }}
   {% endif %}

  {% endif %}

{% endif %}

