#!/bin/sh

# update packages
apt-offline install deps.zip
apt-get install -y -q ruby1.9.1
apt-get install -y -q ruby1.9.1-dev
apt-get install -y -q build-essential
apt-get install -y -q sqlite3
apt-get install -y -q libsqlite3-dev
gem install bundler --version 1.3.5 --local bundler-1.3.5.gem

docker load < testimage.tar
if [ ! -d "/root/airdrop" ]
then
  ls
  mkdir airdrop
  tar -xf airdrop.tar.gz -C airdrop
  cp -a airdrop /root
fi
cd /root/airdrop
# backup fails if these don't exist, need to fix. workaround for now
mkdir -p /docker/airdrop/testimage/data
mkdir -p /docker/airdrop/testimage/logs


bundle install --deployment

### put logic to send poison pill here, application dependent.

# stop will force the image to shut down after 10 seconds
bundle exec ruby airdrop.rb migrate
bundle exec ruby airdrop.rb stop airdrop/testimage
bundle exec ruby airdrop.rb backup airdrop/testimage
bundle exec ruby airdrop.rb start airdrop/testimage "-p 80:80"
