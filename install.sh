#! /bin/bash

yum install -y git
mkdir -p /root/chef/cache
mkdir -p /root/chef/cookbooks
curl -L https://www.chef.io/chef/install.sh | bash -s -- -v 12.7.2
git clone https://github.com/cpressland/cpio-downloads-server.git /root/chef/cookbooks/cpio-downloads-server
git clone https://github.com/chef-cookbooks/yum.git /root/chef/cookbooks/yum
git clone https://github.com/rigrassm/firewalld-cookbook.git /root/chef/cookbooks/firewalld
git clone https://github.com/skottler/selinux.git /root/chef/cookbooks/selinux


echo '
{
  "run_list": [ "recipe[cpio-downloads-server::default]" ]
}' > /root/chef/node.json


echo '
  file_cache_path "/root/chef/cache"
  cookbook_path "/root/chef/cookbooks"
  json_attribs "/root/chef/node.json"
' > /root/chef/solo.rb

sudo chef-solo -c /root/chef/solo.rb -j /root/chef/node.json
