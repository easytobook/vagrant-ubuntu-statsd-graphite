### Graphite and statsd on Ubuntu 12.04 LTS (Precise Pangolin)

~~~~
  vagrant up
~~~~

~~~~
  DEBUG=* phantomas --no-externals --url http://google.com --format statsd --statsd-host localhost --statsd-port 18125 --statsd-prefix "google.home."
~~~~

~~~~~~
https://gist.github.com/nstielau/966835
~~~~~~

## Thanks
Thanks to
https://www.digitalocean.com/community/articles/installing-and-configuring-graphite-and-statsd-on-an-ubuntu-12-04-vps
https://github.com/Jimdo/vagrant-statsd-graphite-puppet