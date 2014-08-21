
httpd:
  pkg.installed

teampass-pkg-reqs:
  pkg.installed:
    - pkgs:
      - php
      - php-mcrypt
      - php-mbstring
      - php-ldap
      - php-mysql
      - openssl

/etc/teampass:
  file.directory:
    - user: apache
    - group: apache
    - mode: 0700

/etc/teampass/sk.php:
  file.managed:
    - template: jinja
    - source: salt://teampass/files/sk.php
    - user: apache
    - group: apache
    - mode: 0400
    - require:
      - file: /etc/teampass

setup_db:
  cmd.script:
    - source: salt://teampass/files/setup_db.sh
    - template: jinja
    - unless: curl -f localhost/teampass/
    - require:
      - git: teampass
      - mysql_database: teampass

/opt/teampass/includes/settings.php:
  file.managed:
    - template: jinja
    - source: salt://teampass/files/settings.php
    - user: apache
    - group: apache
    - mode: 0400
    - require:
      - file: /opt/teampass/includes
      - cmd: setup_db

/etc/httpd/conf.d/teampass.conf:
  file.managed:
    - source: salt://teampass/files/httpd_teampass.conf
    - template: jinja
    - require:
      - pkg: httpd

teampass:
  git.latest:
    - name: 'https://github.com/nilsteampassnet/TeamPass.git'
    - rev: '2.1.20'
    - target: /opt/teampass
  mysql_user.present:
    - name: {{ salt['pillar.get']('teampass:mysql:user', 'teampass') }}
    - host: {{ salt['pillar.get']('teampass:mysql:host', 'localhost') }}
    - password: {{ salt['pillar.get']('teampass:mysql:pass') }}
  mysql_database.present:
    - name: {{ salt['pillar.get']('teampass:mysql:db', 'teampass') }}
  mysql_grants.present:
    - grant: all privileges
    - database: {{ salt['pillar.get']('teampass:mysql:db', 'teampass') }}.*
    - user: {{ salt['pillar.get']('teampass:mysql:user', 'teampass') }}
    - require:
      - mysql_user: teampass
      - mysql_database: teampass

/opt/teampass/install:
  file.directory:
    - user: root
    - group: root
    - mode: 0700
    - require:
      - git: teampass
      - cmd: setup_db
/opt/teampass/includes:
  file.directory:
    - user: apache
    - group: apache
    - mode: 0754
    - require:
      - git: teampass
/opt/teampass/files:
  file.directory:
    - user: apache
    - group: apache
    - mode: 0754
    - require:
      - git: teampass
/opt/teampass/upload:
  file.directory:
    - user: apache
    - group: apache
    - mode: 0754
    - require:
      - git: teampass

