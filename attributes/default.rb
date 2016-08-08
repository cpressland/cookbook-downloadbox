default['downloadbox']['packages'] = %w(wget tar git autofs samba samba-client cifs-utils curl htop vim firewalld)
default['downloadbox']['firewall_services'] = %w(ssh samba http)
default['downloadbox']['basedir'] = "/downloadbox"
default['downloadbox']['basedir_config'] = "#{default['downloadbox']['basedir']}/config"
default['downloadbox']['basedir_downloads'] = "#{default['downloadbox']['basedir']}/downloads"
default['downloadbox']['share_ip'] = "10.0.50.10"
default['downloadbox']['share_name'] = "shared"
default['downloadbox']['tvpath'] = "/media/shared/px01/tv"
default['downloadbox']['moviepath'] = "/media/shared/px01/movies"

default['downloadbox']['directories'] = [
  { :name=>"#{default['downloadbox']['basedir']}" },
  { :name=>"#{default['downloadbox']['basedir_config']}" },
  { :name=>"#{default['downloadbox']['basedir_config']}/nginx" },
  { :name=>"#{default['downloadbox']['basedir_config']}/nginx/conf.d" },
  { :name=>"#{default['downloadbox']['basedir_config']}/nzbget" },
  { :name=>"#{default['downloadbox']['basedir_config']}/sonarr" },
  { :name=>"#{default['downloadbox']['basedir_config']}/couchpotato" },
  { :name=>"#{default['downloadbox']['basedir_downloads']}" },
  { :name=>"#{default['downloadbox']['basedir_downloads']}/nzbget" }
]

default['downloadbox']['templates'] = [
  { :name=>"/etc/auto.shared", :source=>"config.auto.shared.erb", :mode=>"644", :owner=>"root", :group=>"root"},
  { :name=>"/etc/auto.master", :source=>"config.auto.master.erb", :mode=>"644", :owner=>"root", :group=>"root"},
  { :name=>"/etc/samba/smb.conf", :source=>"config.smb.conf.erb", :mode=>"644", :owner=>"root", :group=>"root"},
  { :name=>"/usr/lib/systemd/system/autofs.service", :source=>"systemd.autofs.service.erb", :mode=>"644", :owner=>"root", :group=>"root"},
  { :name=>"#{default['downloadbox']['basedir_config']}/nginx/conf.d/downloadbox.conf", :source=>"config.nginx.sites.erb", :mode=>"644", :owner=>"apps", :group=>"apps"},
  { :name=>"#{default['downloadbox']['basedir_config']}/nzbget/nzbget.conf", :source=>"config.nzbget.conf.erb", :mode=>"644", :owner=>"apps", :group=>"apps"}
]

default['docker']['images'] = [
  { :name=>"cpressland/nginx", :tag=>"latest" },
  { :name=>"cpressland/nzbget", :tag=>"latest" },
  { :name=>"cpressland/sonarr", :tag=>"latest" },
  { :name=>"cpressland/couchpotato", :tag=>"latest" }
]

default['docker']['containers'] = [
  { :name=>"nzbget", :repo=>"cpressland/nzbget", :tag=>"latest", :network_mode=>"downloadbox.local", :volumes=>["#{default['downloadbox']['basedir_config']}/nzbget:/config", "#{default['downloadbox']['basedir_downloads']}/nzbget:/downloads"] },
  { :name=>"sonarr", :repo=>"cpressland/sonarr", :tag=>"latest", :network_mode=>"downloadbox.local", :volumes=>["#{default['downloadbox']['basedir_config']}/sonarr:/config", "#{default['downloadbox']['basedir_downloads']}/nzbget:/downloads", "#{default['downloadbox']['tvpath']}:/tv", '/dev/rtc:/dev/rtc:ro'] },
  { :name=>"couchpotato", :repo=>"cpressland/couchpotato", :tag=>"latest", :network_mode=>"downloadbox.local", :volumes=>["#{default['downloadbox']['basedir_config']}/couchpotato:/config", "#{default['downloadbox']['basedir_downloads']}/nzbget:/downloads", "#{default['downloadbox']['moviepath']}:/movies", '/etc/localtime:/etc/localtime:ro'] },
  { :name=>"nginx", :repo=>"cpressland/nginx", :tag=>"latest", :network_mode=>"downloadbox.local", :port=>"80:80", :volumes=>['config_nginx:/etc/nginx',  "#{default['downloadbox']['basedir_config']}/nginx/conf.d/downloadbox.conf:/etc/nginx/conf.d/downloadbox.conf"] }
]
