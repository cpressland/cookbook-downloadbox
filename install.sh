#! /bin/bash

read -p "What is the IP Address of your NAS: " share_ip;
read -p "What is the Name of the Share on your NAS, note that this needs to allow anon-binds: " share_name;
echo "Now I need to know the path to your content, without the share IP and name, so \\\\192.168.0.2\\stuff\\plex\\tv would just be plex/tv"
read -p "What is the path to your TV shows: " tv_path;
read -p "What is the path to your Movies: " movie_path;

yum install -y git
mkdir -p /var/chef/cache
mkdir -p /var/chef/cookbooks
curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 12.7.2
git clone https://github.com/cpressland/cpio-downloads-server.git /var/chef/cookbooks/downloadbox
git clone https://github.com/rigrassm/firewalld-cookbook.git /var/chef/cookbooks/firewalld
git clone https://github.com/skottler/selinux.git /var/chef/cookbooks/selinux
git clone https://github.com/chef-cookbooks/docker.git /var/chef/cookbooks/docker
git clone https://github.com/chef-cookbooks/compat_resource.git /var/chef/cookbooks/compat_resource

echo '
{
  "downloadbox": {
    "share_ip": "'$share_ip'",
    "share_name": "'$share_name'",
    "tvpath": "/media/shared/'$tv_path'",
    "moviepath": "/media/shared/'$movie_path'"
  },
  "run_list": [ "recipe[downloadbox::default]" ]
}' > /var/chef/node.json


echo '
  file_cache_path "/var/chef/cache"
  cookbook_path "/var/chef/cookbooks"
  json_attribs "/var/chef/node.json"
' > /var/chef/solo.rb

sudo chef-solo -c /var/chef/solo.rb -j /var/chef/node.json
