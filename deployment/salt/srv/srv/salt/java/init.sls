{% from "java/map.jinja" import java with context %}
{% set distribution = salt['pillar.get']('java_dist', 'jdk') %}

java:
  pkg.installed:
    - version: {{ java[distribution]['version'] }}
    - name: {{ java[distribution]['package'] }}

