{% from "jenkins/map.sls" import jenkins with context %}

jenkins:
  pkgrepo.managed:
    - humanname: Jenkins repository
{% if salt['grains.get']('os_family') == 'Debian' %}
    - name: {{ jenkins.repo_name }}
    - key_url: {{ jenkins.key_url }}
    - refresh_db: true
    - file: {{ jenkins.apt_repo_file }}
{% endif %}
{% if salt['grains.get']('os_family') == 'Redhat' %}
    - baseurl: {{ jenkins.repo_url }}
    - name: {{ jenkins.repo_name }}
    - gpgkey: {{ jenkins.key_url }}
{% endif %}
  pkg.installed:
    - name: {{ jenkins.pkg_name }}
  service.running:
    - name: jenkins
    - enable: True
