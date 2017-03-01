FROM ubuntu:16.04
LABEL owner=kkalynovskyi@mirantis.com
ARG KEYURL="https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub"
ARG REPOSTRING="deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main"
ARG SALTPACKAGES="salt-master salt-cloud"
RUN apt-get update -q && apt-get install -y apt-utils wget
RUN wget -O - $KEYURL | apt-key add -
RUN echo $REPOSTRING > /etc/apt/sources.list.d/saltstack.list
RUN apt-get update -q && apt-get install -y $SALTPACKAGES
COPY deployment/salt/etc /etc/salt
ENTRYPOINT /usr/bin/python /usr/bin/salt-master
RUN salt-cloud --assume-yes --parallel -m /etc/salt/minion_map

