base:
  'role:salt-master':
    - match: pillar
    - configure_hosts
    - salt-master
  'role:salt-minion':
    - match: pillar
    - salt-minion
