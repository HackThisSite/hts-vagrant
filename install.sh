#!/bin/bash

CONFIGS='/data/configs'
HTS='/data/hackthissite'

# Add some sources.
echo 'deb http://packages.dotdeb.org stable all' >> /etc/apt/sources.list
echo 'deb-src http://packages.dotdeb.org stable all' >> /etc/apt/sources.list

apt-get update
apt-get -yq install git libpcre3-dev mongodb nginx php5 php-apc
apt-get -yq install php-pear php5-fpm php5-sqlite redis-doc redis-server sqlite3
pecl install apc bbcode mongo
apt-get -yq upgrade # Always stay up-to-date.

# ElasticSearch
cd /tmp
wget https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.8.deb
dpkg -i elasticsearch-0.19.8.deb
apt-get -yqf install # Grab the elasticsearch depends

# phpredis
git clone https://github.com/nicolasff/phpredis.git /tmp/phpredis
cd phpredis
phpize; ./configure; make && make installl; cd

# MsgPack for php
pecl channel-discover php-msgpack.googlecode.com/svn/pecl
pecl install msgpack/msgpack-beta

# BrowsCap
# What do I do here!?!

# Configurations
cat $CONFIGS/append-php.ini >> /etc/php.ini
cat $CONFIGS/hackthissite-nginx.conf > /etc/nginx/sites-available/hackthissite
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/hackthissite /etc/nginx/sites-enabled/
cd $HTS/application/configs/servers
mkdir dev.hts
cat $CONFIGS/override.php > dev.hts/override.php
