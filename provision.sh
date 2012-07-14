#!/usr/bin/env bash

#
# Note: This shell script will soon be replaced with puppet configs.
# The format of adding a depend here is as follows:
#    # <DEPENDNAME>
#    # Install the depend.
#    # Add to boot scripts via update-rc.d.
#    # Start the application if needed.
#

# Vars
# Vagrantfile mounts ./data to /data on the vm
CONFIGS='/data/configs'
HTS='/data/hackthissite'
APT='apt-get -f --force-yes -qq'
INIT='/etc/init.d'

# Add dotdeb repo
echo 'deb http://packages.dotdeb.org stable all' >> /etc/apt/sources.list
echo 'deb-src http://packages.dotdeb.org stable all' >> /etc/apt/sources.list
curl -OLs http://www.dotdeb.org/dotdeb.gpg
cat dotdeb.gpg | sudo apt-key add -
rm dotdeb.gpg

# Update.
$APT update
# $APT upgrade

# Basic depends
echo Installing basic depends.
$APT install git libpcre3-dev sqlite3

# Nginx
echo Installing Nginx.
$APT install nginx
update-rc.d nginx defaults

# PHP
echo Installing PHP-related depends.
$APT install php5-dev php5-fpm php5-apc php-pear php5-sqlite php5-redis libmsgpack-dev
yes | pecl install apc bbcode mongo
cp $CONFIGS/apc.ini /etc/php5/conf.d/apc.ini
update-rc.d php5-fpm defaults

# MongoDB
echo Installing MongoDB.
$APT install mongodb
update-rc.d mongodb defaults

# Redis
echo Installing Redis.
$APT install redis-server redis-doc
update-rc.d redis-server defaults

# ElasticSearch - please try to keep the elastic link updated.
echo Installing ElasticSearch.
$APT install openjdk-6-jre-headless
curl -OLs https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.8.deb
dpkg -i elasticsearch-0.19.8.deb
rm elasticsearch-0.19.8.deb
#cp /data/configs/elasticsearch-initscript /etc/init.d/elasticsearch
update-rc.d elasticsearch defaults

# BrowsCap
echo Installing Browscap.
cp $CONFIGS/php_browscap.ini /etc/php5/conf.d/

# HackThisSite Setup
echo Setting up HackThisSite.
cp $CONFIGS/hts.ini /etc/php5/conf.d/
cp $CONFIGS/hackthissite-nginx.conf /etc/nginx/sites-available/hackthissite
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/hackthissite /etc/nginx/sites-enabled/

# Start needed services.
$INIT/nginx restart
$INIT/php5-fpm restart
$INIT/mongodb restart
$INIT/redis-server restart
$INIT/elasticsearch restart

# Done
echo Done?!? Yes. Have fun.
