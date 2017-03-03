{% from "java/map.jinja" import java with context %}
echo {{ java.jdk.package }}:
  cmd.run
