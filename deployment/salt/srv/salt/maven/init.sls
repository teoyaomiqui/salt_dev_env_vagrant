{% from 'maven/settings.jinja' import maven with context %}

include:
  - {{ 'maven.' + maven.install_method }}
