#!/usr/bin/env bash

# Install nginx.
# Link our nginx config in, so we can serve our application.
apt-get update
apt-get install -y nginx
ln -s /home/vagrant/galileo.conf /etc/nginx/sites-enabled/galileo.conf
service nginx reload

# Install Dart
apt-get install -y apt-transport-https
sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
apt-get update
apt-get install -y dart

# Add Dart to PATH
echo 'PATH="/usr/lib/dart/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Finally, link our new service.
ln -s /home/vagrant/galileo.service /etc/systemd/system/galileo.service
systemctl daemon-reload
systemctl enable galileo
