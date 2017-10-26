{% from "datagrip/map.jinja" import datagrip with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
datagrip-home-alt-install:
  alternatives.install:
    - name: datagriphome
    - link: {{ datagrip.symhome }}
    - path: {{ datagrip.alt.realhome }}
    - priority: {{ datagrip.alt.priority }}

datagrip-home-alt-set:
  alternatives.set:
    - name: datagriphome
    - path: {{ datagrip.alt.realhome }}
    - onchanges:
      - alternatives: datagrip-home-alt-install

# Add to alternatives system
datagrip-alt-install:
  alternatives.install:
    - name: datagrip
    - link: {{ datagrip.symlink }}
    - path: {{ datagrip.alt.realcmd }}
    - priority: {{ datagrip.alt.priority }}
    - require:
      - alternatives: datagrip-home-alt-install
      - alternatives: datagrip-home-alt-set

datagrip-alt-set:
  alternatives.set:
    - name: datagrip
    - path: {{ datagrip.alt.realcmd }}
    - onchanges:
      - alternatives: datagrip-alt-install

  {% endif %}

{% endif %}
