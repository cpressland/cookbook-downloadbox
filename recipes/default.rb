#
# Cookbook Name:: downloadbox
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# --- Attribute Definitions

dirvars  = node['downloadbox']['directories']
temvars  = node['downloadbox']['templates']
imgvars  = node['docker']['images']
contvars = node['docker']['containers']

# --- Disable SELinux (I'll learn it one day)

selinux_state "Disable SELinux" do
  action :disabled
end

# --- Add user for apps to run under

group 'apps' do
  gid 1550
  action :create
end

user 'apps' do
  uid 1550
  gid 1550
  system true
  shell '/bin/bash'
  action :create
end

# --- Install required packages

package 'epel-release' do
  action :install
end

node['downloadbox']['packages'].each do |package_name|
  package package_name do
    action :install
  end
end

# --- Create Directory Structures

dirvars.each do |createdirs|
  directory createdirs[:name] do
    owner 'apps'
    group 'apps'
    mode '755'
    action :create
  end
end

# --- Deploy Templates

temvars.each do |createtems|
  template createtems[:name] do
    source createtems[:source]
    owner createtems[:owner]
    group createtems[:group]
    mode createtems[:mode]
  end
end

# --- Configure the firewall

service 'firewalld' do
  action [:enable, :start]
end

node['downloadbox']['firewall_services'].each do |service_name|
  firewalld_service service_name do
    action :add
    zone 'public'
  end
end

# --- Start AutoFS and Samba before Docker

service 'autofs' do
  action [:enable, :start]
end

service 'smb' do
  action [:enable, :start]
end

# --- Install Docker and Start it.

docker_service 'default' do
  action [:create, :start]
end

group 'docker' do
  action :modify
  members 'apps'
  append true
end

docker_network 'downloadbox.local' do
  subnet '10.0.51.0/24'
  gateway '10.0.51.1'
  action :create
end

imgvars.each do |dimages|
  docker_image dimages[:name] do
    tag dimages[:tag]
    action :pull
  end
end

contvars.each do |containers|
 docker_container containers[:name] do
   repo containers[:repo]
   tag containers[:tag]
   port containers[:port]
   network_mode containers[:network_mode]
   volumes containers[:volumes]
   restart_policy 'always'
 end
end
