## adjust /etc/hosts file on all nodes, for hostname resolution
{% for host in pillar["hosts"] %} 
{{ host["hostname"] }}: 
  host.present:
    - ip: {{ host["ip"] }}
    - names:
      - {{ host["hostname"] }}
{% endfor %}
