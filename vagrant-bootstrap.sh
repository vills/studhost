#!/usr/bin/env bash


if [[ ! -d /var/www/.panel ]]; then
  sed -i 's|http.us.debian.org|mirror.yandex.ru|g' /etc/apt/sources.list

  apt-get update -y
  apt-get install ruby1.9.1-full rubygems curl libsqlite3-dev libmysqlclient-dev -y 

  curl -L -o /tmp/chef-omnibus.deb 'http://vagrantboxes.vills.me/chef_11.4.4-2.debian.6.0.5_amd64.deb' \
    && dpkg -i /tmp/chef-omnibus.deb

  gem list | grep 'bundler' > /dev/null || gem install bundler

  cat /root/.bashrc | grep export | grep gems > /dev/null || echo 'export PATH=/var/lib/gems/1.8/bin/:${PATH}' >> ~/.bashrc

  . ~/.bashrc

  mkdir -p /var/www/.panel
  cp -R /vagrantfiles/* /var/www/.panel/
  chown -R www-data:www-data /var/www/.panel

  pushd /var/www/.panel
  bundle install
  rake upgradedb
  popd

  chef-solo -c /var/www/.panel/deploy/chef-solo.rb -j /var/www/.panel/deploy/chef-solo.json

  service thin restart
else
  cp -R /vagrantfiles/* /var/www/.panel/
  chown -R www-data:www-data /var/www/.panel

  # pushd /var/www/.panel
  # bundle install
  # rake upgradedb
  # popd
  
  service thin restart
fi
