#
# Cookbook Name:: cpio-downloads-server
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

# --- Attribute Definitions

uservars = node['cpio-downloads-server']['users']
repovars = node['cpio-downloads-server']['repositories']
dirvars  = node['cpio-downloads-server']['directories']
temvars  = node['cpio-downloads-server']['templates']
fwsvars  = node['firewalld']['firewalld_services']
fwpvars  = node['firewalld']['firewalld_ports']

# --- Set SELinux to Disabled, Sonarr does not support it.

selinux_state "Disable SELinux" do
  action :disabled
end

# --- Install Required Yum Repo's

repovars.each do |createrepos|
  yum_repository createrepos[:reponame] do
    description createrepos[:repodescription]
    baseurl createrepos[:repobaseurl]
    gpgkey createrepos[:repogpgkey]
    action :create
  end
end

# --- Add Required Users

uservars.each do |createusers|
  group createusers[:name]

  user createusers[:name] do
    group createusers[:name]
    home createusers[:home]
    system false
    shell '/bin/bash'
  end
end

# --- Install required packages

node['cpio-downloads-server']['packages'].each do |package_name|
  package package_name do
    action :install
  end
end

# --- Update Shell from Bash to Fish on Root User

execute 'Use Fish instead of Bash for Root User' do
  command "chsh -s /usr/bin/fish root"
  action :run
  only_if { node['fish']['replace_bash'] }
end

# --- Create Directory Structures

dirvars.each do |createdirs|
  directory createdirs[:dirname] do
    owner createdirs[:dirowner]
    group createdirs[:dirgroup]
    mode createdirs[:dirmode]
    action :create
  end
end

# --- Deploy Templates

temvars.each do |createtems|
  template createtems[:temname] do
    source createtems[:temsource]
    owner createtems[:temowner]
    group createtems[:temgroup]
    mode createtems[:temmode]
  end
end

# --- Configure FirewallD

service "firewalld" do
  only_if { node['firewalld']['enable_firewalld'] }
  action [:enable, :start]
end

service "firewalld" do
  not_if { node['firewalld']['enable_firewalld'] }
  action [:disable, :stop]
end

fwpvars.each do |fwpconf|
  firewalld_port fwpconf[:fwport] do
    action :add
    zone fwpconf[:fwzone]
    only_if { node['firewalld']['enable_firewalld'] }
  end
end

fwsvars.each do |fwsconf|
  firewalld_service fwsconf[:fwservice] do
    action :add
    zone fwsconf[:fwzone]
    only_if { node['firewalld']['enable_firewalld'] }
  end
end

# --- Enable or Disable SMB

service "smb" do
  only_if { node['smb']['enable_smb'] }
  action [:enable, :start]
end

service "smb" do
  not_if { node['smb']['enable_smb'] }
  action [:disable, :stop]
end

# --- Install NZBGet

execute 'Download NZBGet Installer' do
  command 'wget -O - http://nzbget.net/info/nzbget-version-linux.json | sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | wget --no-check-certificate -i - -O /tmp/nzbget-latest-bin-linux.run'
  action :run
  not_if { File.exist?("#{node['cpio-downloads-server']['apps_homedirectory']}/nzbget/nzbget") }
end

execute 'Install NZBGet' do
  command "sh /tmp/nzbget-latest-bin-linux.run --destdir #{node['cpio-downloads-server']['apps_homedirectory']}/nzbget"
  action :run
  not_if { File.exist?("#{node['cpio-downloads-server']['apps_homedirectory']}/nzbget/nzbget") }
end

file '/tmp/nzbget-latest-bin-linux.run' do
  action :delete
end

# --- Install Sonarr

execute 'Download Sonarr Tar File' do
  command 'wget http://download.sonarr.tv/v2/master/mono/NzbDrone.master.tar.gz -O /tmp/NzbDrone.master.tar.gz'
  not_if { File.exist?("#{node['cpio-downloads-server']['apps_homedirectory']}/NzbDrone/NzbDrone.exe") }
  action :run
end

execute 'Install Sonarr' do
  command "tar zxf /tmp/NzbDrone.master.tar.gz -C #{node['cpio-downloads-server']['apps_homedirectory']}/"
  action :run
  not_if { File.exist?("#{node['cpio-downloads-server']['apps_homedirectory']}/NzbDrone/NzbDrone.exe") }
end

file '/tmp/NzbDrone.master.tar.gz' do
  action :delete
end

# --- Install CouchPotato

git "#{node['cpio-downloads-server']['apps_homedirectory']}/couchpotato" do
  repository 'https://github.com/RuudBurger/CouchPotatoServer.git'
  revision 'master'
  action :sync
  not_if { File.exist?("#{node['cpio-downloads-server']['apps_homedirectory']}/couchpotato/CouchPotato.py") }
end

# --- Chown the app user to quickly fix any permissions

execute 'chown apps user' do
  command "chown -R #{node['cpio-downloads-server']['apps_username']}:#{node['cpio-downloads-server']['apps_username']} #{node['cpio-downloads-server']['apps_homedirectory']}"
  action :run
end

# --- Enable Services

node['cpio-downloads-server']['services'].each do |servs|
  service servs do
    action :enable
  end
end
