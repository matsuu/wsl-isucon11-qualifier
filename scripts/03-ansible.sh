#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends ansible curl git

GITDIR="/tmp/isucon11-qualify"
rm -rf ${GITDIR}
git clone --depth=1 https://github.com/isucon/isucon11-qualify.git ${GITDIR}
(
  cd ${GITDIR}/provisioning/ansible
  #
  curl -sL https://github.com/isucon/isucon11-qualify/releases/download/public/1_InitData.sql > roles/contestant/files/initial-data.sql
  curl -sL https://github.com/isucon/isucon11-qualify/releases/download/public/initialize.json > roles/bench/files/initialize.json
  #
  openssl x509 -in <(openssl req -subj '/CN=*.t.isucon.dev' -nodes -newkey rsa:2048 -keyout roles/contestant/files/etc/nginx/certificates/tls-key.pem) -req -signkey roles/contestant/files/etc/nginx/certificates/tls-key.pem -sha256 -days 3650 -out roles/contestant/files/etc/nginx/certificates/tls-cert.pem -extfile <(echo -e "basicConstraints=critical,CA:true,pathlen:0\nsubjectAltName=DNS.1:*.t.isucon.dev")
  sed -i -e '/InsecureSkipVerify/s/=.*/= true/' ../../bench/main.go
  #
  sed -i -e '/timezone/d' roles/common/tasks/main.yml
  #
  sed -i -e '/name.*Deploy/,/dest/d' -e 's/^$/    recurse: yes/' roles/common/tasks/isucon11-qualify.yml
  #
  mkdir -p /var/lib/cloud/scripts/per-instance
  sed -i -e '/^index=/s/=.*/=1/' roles/contestant/files/var/lib/cloud/scripts/per-instance/generate-env_aws.sh
  sed -i -e 's/192\.168\.0\.11/127\.0\.0\.1/' roles/contestant/files/etc/hosts
  #
  ansible-playbook -i standalone.hosts --connection=local site.yml
  /var/lib/cloud/scripts/per-instance/generate-env.sh
)
rm -rf ${GITDIR}

apt-get remove -y --purge ansible
apt-get autoremove -y
#
