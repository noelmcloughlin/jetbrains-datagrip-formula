{% from "datagrip/map.jinja" import datagrip with context %}

# Cleanup first
datagrip-remove-prev-archive:
  file.absent:
    - name: '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}'
    - require_in:
      - datagrip-install-dir

datagrip-install-dir:
  file.directory:
    - names:
      - '{{ datagrip.jetbrains.realhome }}'
      - '{{ datagrip.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows',) %}
      - '{{ datagrip.prefix }}'
      - '{{ datagrip.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - clean: True
    - require_in:
      - datagrip-download-archive

datagrip-download-archive:
  cmd.run:
    - name: curl {{ datagrip.dl.opts }} -o '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}' {{ datagrip.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ datagrip.dl.retries }}
        interval: {{ datagrip.dl.interval }}
      {% endif %}

{% if grains.os not in ('MacOS',) %}
datagrip-unpacked-dir:
  file.directory:
    - name: '{{ datagrip.jetbrains.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: datagrip-download-archive
{% endif %}

{%- if datagrip.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',) %}
datagrip-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}'
     - file_hash: {{ datagrip.dl.src_hashsum }}
     - onchanges:
       - cmd: datagrip-download-archive
     - require_in:
       - archive: datagrip-package-install
  {%- endif %}
{%- endif %}

datagrip-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  archive.extracted:
    - source: 'file://{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}'
    - name: '{{ datagrip.jetbrains.realhome }}'
    - archive_format: {{ datagrip.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ datagrip.dl.unpack_opts }}
    - if_missing: '{{ datagrip.jetbrains.realcmd }}'
       {% else %}
    - options: {{ datagrip.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if datagrip.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ datagrip.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: datagrip-download-archive
    - require_in:
      - datagrip-remove-archive

datagrip-remove-archive:
  file.absent:
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}'
      - '{{ datagrip.tmpdir }}/{{ datagrip.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows',) %}
      - pkg: datagrip-package-install
{%- elif grains.os in ('MacOS',) %}
      - macpackage: datagrip-package-install
{% else %}
      - archive: datagrip-package-install

datagrip-home-symlink:
  file.symlink:
    - name: '{{ datagrip.symhome }}'
    - target: '{{ datagrip.jetbrains.realhome }}'
    - force: True
    - onchanges:
      - archive: datagrip-package-install

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
      datagrip_home: '{{ datagrip.symhome }}'

{% endif %}
