{% from "java/map.jinja" import java with context %}
{% set distribution = salt['pillar.get']('java_dist', 'jdk') %}
{% if 'headless' in java[distribution]['package'] %}
  {% set jre_flag = '--jre-headless' %}
{% else %}
  {% set jre_flag = '--jre' %}
{% endif %}

include:
  - java

{% if salt['pillar.get']('set_java_home', True) %}
config_java_home:
  file.replace:
    - name: /etc/environment
    - repl: {{ 'JAVA_HOME=' + java[distribution]['java_home'] }}
    - pattern: '^JAVA_HOME=.*$'
    - prepend_if_not_found: True
{% endif %}

{% if salt['pillar.get']('use_alternatives', False) %}
set_java_alternatives:
  cmd.run:
    - name: {{ ['update-java-alternatives', '--set', java[distribution]['alternative'], jre_flag]|join(' ') }}
    - unless: {{ 'test /etc/alternatives/java -ef ' + java[distribution]['alternative_path'] }}
{% endif %}
