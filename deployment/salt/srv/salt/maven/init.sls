{% from 'maven/map.jinja' import maven with context %}

include:
  - {{ 'maven.' + maven.install_method }}
