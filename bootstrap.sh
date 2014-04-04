#!/usr/bin/env bash


#===========================Installing Graphite
# Get the updates
sudo apt-get update
sudo apt-get upgrade


#Install the needed packages:
sudo apt-get install --assume-yes apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 build-essential python3.2 python-dev libpython3.2 python3-minimal libapache2-mod-wsgi libaprutil1-ldap memcached python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect libapache2-mod-python python-setuptools python-pip

#python-setuptool's "easy_install" utility to install a few more important python components:
sudo easy_install django-tagging==0.3.1 zope.interface twisted txamqp

# ==================================
# TODO FIX
# sudo pip uninstall django-tagging
# sudo pip install django-tagging==0.3.1

# TODO FIX 2
# Get latest pip
# sudo pip install --upgrade pip

# # Install carbon and graphite deps
# cat >> /tmp/graphite_reqs.txt << EOF
# django==1.3
# python-memcached
# django-tagging==0.3.1
# twisted
# whisper==0.9.9
# carbon==0.9.9
# graphite-web==0.9.9
# EOF

# sudo pip install -r /tmp/graphite_reqs.txt

# ====================

#Carbon is the data aggregator, Graphite web is the web component, and whisper is the database library:
cd ~
wget https://launchpad.net/graphite/0.9/0.9.10/+download/graphite-web-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/carbon-0.9.10.tar.gz
wget https://launchpad.net/graphite/0.9/0.9.10/+download/whisper-0.9.10.tar.gz

#Use tar to extract the archives:
find *.tar.gz -exec tar -zxvf '{}' \;

# Install whisper database
cd whisper*
sudo python setup.py install

# Install carbon
cd ../carbon*
sudo python setup.py install

# And Graphite
cd ../graphite*
sudo python check-dependencies.py
sudo python setup.py install

# =========================Configure Graphite
cd /opt/graphite/conf
sudo cp carbon.conf.example carbon.conf

# Grab storage configuration
sudo cp /vagrant/storage-schemas.conf .
sudo cp /vagrant/storage-aggregation.conf .


# Manage graphite DB
cd /opt/graphite/webapp/graphite/
sudo python manage.py syncdb --noinput

#Copy the local settings example file to the production version
sudo cp local_settings.py.example local_settings.py

#====================Configure Apache

# copying some more example configuration files:
sudo cp ~/graphite*/examples/example-graphite-vhost.conf /etc/apache2/sites-available/default
sudo cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi

# Give the Apache web user ownership of Graphite's storage directory so that it can write data properly:
sudo chown -R www-data:www-data /opt/graphite/storage

# Create a directory for our WSGI data:
sudo mkdir -p /etc/httpd/wsgi

#TODO WSGISocketPrefix to reflect the directory we just created
sudo sed -i "s/run\/wsgi/\/etc\/httpd\/wsgi/g" /etc/apache2/sites-available/default

# Restart Apache to implement our changes:
sudo service apache2 restart

#=====================================Installing and Configuring Statsd

# To use statsd, we need to install node.js. To do this, we will install "python-software-properties", which contains a utility to add PPAs:
sudo apt-get install python-software-properties

# We can now add the appropriate PPA:
sudo apt-add-repository ppa:chris-lea/node.js

#Install nodejs and git
sudo apt-get update
sudo apt-get install --assume-yes nodejs git

# Now clone the git repository into our optional software directory:
cd /opt
sudo git clone git://github.com/etsy/statsd.git

# Create the configuration file for statsd within the new statsd directory:
sudo cp /vagrant/localConfig.js /opt/statsd/



#===============================Starting the Services
# Start the carbon data aggregator so that it will begin sending data:
sudo /opt/graphite/bin/carbon-cache.py start

# move to the statsd directory and run the files by using the node.js command:
cd /opt/statsd
node ./stats.js ./localConfig.js
