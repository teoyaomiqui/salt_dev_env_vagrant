{% from 'maven/map.jinja' import maven with context %}

deploy_maven:
  archive.extracted:
    - name: {{ '/opt' }}
    - source: {{ 'http://www.us.apache.org/dist/maven/maven-3/' + maven.install_options.version + '/binaries/apache-maven-' + '3.3.9' + '-bin.tar.gz' }}
    - source_hash: {{ 'http://www.us.apache.org/dist/maven/maven-3/' + maven.install_options.version + '/binaries/apache-maven-' + maven.install_options.version + '-bin.tar.gz.sha1' }}

  alternatives.install:
    - name: maven
    - link: '/usr/bin/mvn'
    - path: {{ '/opt/apache-maven-' + maven.install_options.version + '/bin/mvn' }}
    - priority: 30
