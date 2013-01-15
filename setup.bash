#!/bin/bash

# dependency for add-apt-repository
sudo apt-get install -y python-software-properties

## install dionaea ##

#add dionaea repo
sudo add-apt-repository -y ppa:honeynet/nightly
sudo apt-get update
sudo apt-get install -y dionaea

#make directories
sudo mkdir -p /var/dionaea/wwwroot
sudo mkdir -p /var/dionaea/binaries
sudo mkdir -p /var/dionaea/log
sudo chown -R nobody:nogroup /var/dionaea/

#edit config
sudo mv /etc/dionaea/dionaea.conf.dist /etc/dionaea/dionaea.conf
sudo sed -i 's/var\/dionaea\///g' /etc/dionaea/dionaea.conf
sudo sed -i 's/log\//\/var\/dionaea\/log\//g' /etc/dionaea/dionaea.conf

#launch dionaea
sudo dionaea -c /etc/dionaea/dionaea.conf -w /var/dionaea -u nobody -g nogroup -D

## install kippo - we want the latest so we have to grab the source ##

#kippo dependencies
sudo apt-get install -y subversion python-dev openssl python-openssl python-pyasn1 python-twisted iptables

#install kippo to /opt/kippo
sudo mkdir /opt/kippo/
sudo svn checkout http://kippo.googlecode.com/svn/trunk/ /opt/kippo/
sudo mv /opt/kippo/kippo.cfg.dist /opt/kippo/kippo.cfg

#add kippo user that can't login
sudo useradd -r -s /bin/false kippo

#set up permissions
sudo chown -R kippo:kippo /opt/kippo/

sudo -u kippo sh start.sh

sudo iptables -t nat -A PREROUTING -i IN_IFACE -p tcp --dport 22 -j REDIRECT --to-port 2222
