## Graphite and statsD on Ubuntu 12.04 LTS (Precise Pangolin)



1. clone this repo
2. ```vagrant up```
3. ```vagrant ssh```
4. ```sudo npm install -g phantomas```
5. ```DEBUG=* phantomas --no-externals --url http://easytobook.com --format statsd --statsd-host localhost --statsd-port 8125 --statsd-prefix "etb.home."```


=========

Write statsD data from bash
https://gist.github.com/nstielau/966835


**Thanks to**
* https://www.digitalocean.com/community/articles/installing-and-configuring-graphite-and-statsd-on-an-ubuntu-12-04-vps
* https://github.com/Jimdo/vagrant-statsd-graphite-puppet
