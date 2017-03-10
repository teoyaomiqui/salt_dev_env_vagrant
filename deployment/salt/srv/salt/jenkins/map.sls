{% set jenkins = salt['grains.filter_by']({
    'Redhat':{
        'repo_name': '/etc/yum.repos.d/jenkins.repo',
        'pkg_name': jenkins,
        'repo_url': 'http://pkg.jenkins-ci.org/redhat/jenkins.repo',
        'key_url': 'https://jenkins-ci.org/redhat/jenkins-ci.org.key'
        },
    'Debian':{
        'repo_name': 'deb http://pkg.jenkins-ci.org/debian-stable binary/',
        'key_url': 'https://pkg.jenkins.io/debian/jenkins-ci.org.key',
        'apt_repo_file': '/etc/apt/sources.list.d/jenkins.list',
        'pkg_name': 'jenkins'
        }
    }, merge=salt['pillar.get']('jenkins:lookup'))
%}

