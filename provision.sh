#!/usr/bin/env bash

# Vars
# Vagrantfile mounts ./data to /data on the vm
CONFIGS='/data/configs'
HTS='/data/hackthissite'
APT='apt-get -f -y --force-yes'
INIT='/etc/init.d/'

# Add some sources.
# php5-fpm repo
echo 'deb http://packages.dotdeb.org stable all' >> /etc/apt/sources.list
echo 'deb-src http://packages.dotdeb.org stable all' >> /etc/apt/sources.list

# Update.
$APT update
# $APT upgrade

# Just some depends
echo Installing depends.
$APT install git libpcre3-dev sqlite3

# PHP
echo Installing PHP-related depends.
$APT install php5-dev php5-fpm php-apc php-pear php5-sqlite
yes | pecl install apc bbcode mongo
update-rc.d php5-fpm defaults

# Nginx
echo Installing Nginx.
$APT install nginx
update-rc.d nginx defaults

# MongoDB
echo Installing MongoDB.
$APT install mongodb
update-rc.d mongodb defaults

# Redis
echo Installing Redis.
$APT install redis-server redis-doc
update-rc.d redis defaults

# ElasticSearch - please try to keep the elastic link updated.
echo Installing ElasticSearch
$APT install openjdk-6-jre-headless
curl -OL https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.8.zip
unzip elasticsearch-* && rm elasticsearch-*.zip
mv elasticsearch-* /usr/local/elasticsearch
mv /data/configs/elasticsearch-initscript /etc/init.d/elasticsearch
chmod +x /etc/init.d/elasticsearch
update-rc.d elasticsearch defaults

# phpredis
echo Installing phpredis
git clone https://github.com/nicolasff/phpredis.git /tmp/phpredis
cd phpredis
phpize; ./configure; make && make installl; cd

# MsgPack for php
echo Installing MsgPack for PHP.
yes | pecl channel-discover php-msgpack.googlecode.com/svn/pecl
yes | pecl install msgpack/msgpack-beta

# BrowsCap
echo Installing Browscap.
cp $CONFIGS/php_browscap.ini /etc/php5/conf.d/

# HackThisSite Setup
echo Setting up HackThisSite.
cp $CONFIGS/hts.ini /etc/php5/conf.d/
cp $CONFIGS/hackthissite-nginx.conf /etc/nginx/sites-available/hackthissite
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/hackthissite /etc/nginx/sites-enabled/
mkdir $HTS/application/configs/servers/dev.hts
cp $CONFIGS/override.php $HTS/application/configs/servers/dev.hts/override.php

# Start Stuff
echo Starting all needed servers.
nginx start
php5-fpm start
mongodb start
redis start
elasticsearch start
