default['cpio-downloads-server']['apps_username'] = "apps"
default['cpio-downloads-server']['apps_homedirectory'] = "/home/#{default['cpio-downloads-server']['apps_username']}"
default['cpio-downloads-server']['my_username'] = "cpressland"
default['cpio-downloads-server']['my_homedirectory'] = "/home/#{default['cpio-downloads-server']['my_username']}"
default['cpio-downloads-server']['replace_bash'] = true

default['cpio-downloads-server']['packages'] = %w(mediainfo gettext wget nano tar git autofs samba samba-client cifs-utils curl htop mono-devel sqlite yum-utils glances vim fish firewalld qbittorrent-nox)
default['cpio-downloads-server']['services'] = %w(nzbget qbittorrent sonarr couchpotato autofs)
default['cpio-downloads-server']['share_ip'] = "10.0.50.10"
default['cpio-downloads-server']['share_name'] = "shared"

default['firewalld']['enable_firewalld'] = true
default['qbittorrent']['port'] = "51413"


default['cpio-downloads-server']['users']          = [
  { :name=>"#{default['cpio-downloads-server']['apps_username']}", :home=> "#{default['cpio-downloads-server']['apps_homedirectory']}" },
  { :name=>"#{default['cpio-downloads-server']['my_username']}", :home=> "#{default['cpio-downloads-server']['my_homedirectory']}" }
]

default['cpio-downloads-server']['repositories']   = [
  { :reponame=>"epel", :repodescription=>"Extra Packages for Enterprise Linux", :repobaseurl=>"http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/7/x86_64/", :repogpgkey=>"http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7"},
  { :reponame=>"shells:fish:release:2", :repodescription=>"Fish shell - 2.x release series (CentOS_7)", :repobaseurl=>"http://download.opensuse.org/repositories/shells:/fish:/release:/2/CentOS_7/", :repogpgkey=>"http://download.opensuse.org/repositories/shells:/fish:/release:/2/CentOS_7//repodata/repomd.xml.key"},
  { :reponame=>"mono-project", :repodescription=>".NET Framework for Linux", :repobaseurl=>"http://download.mono-project.com/repo/centos/", :repogpgkey=>"http://download.mono-project.com/repo/xamarin.gpg"}
]

default['cpio-downloads-server']['directories']    = [
  { :dirname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config", :dirowner=>"#{default['cpio-downloads-server']['apps_username']}", :dirgroup=>"#{default['cpio-downloads-server']['apps_username']}", :dirmode=>"755" },
  { :dirname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/nzbget", :dirowner=>"#{default['cpio-downloads-server']['apps_username']}", :dirgroup=>"#{default['cpio-downloads-server']['apps_username']}", :dirmode=>"755" },
  { :dirname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/qBittorrent", :dirowner=>"#{default['cpio-downloads-server']['apps_username']}", :dirgroup=>"#{default['cpio-downloads-server']['apps_username']}", :dirmode=>"755" },
  { :dirname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/couchpotato", :dirowner=>"#{default['cpio-downloads-server']['apps_username']}", :dirgroup=>"#{default['cpio-downloads-server']['apps_username']}", :dirmode=>"755" },
  { :dirname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/NzbDrone", :dirowner=>"#{default['cpio-downloads-server']['apps_username']}", :dirgroup=>"#{default['cpio-downloads-server']['apps_username']}", :dirmode=>"755" }
]

default['cpio-downloads-server']['templates']    = [
 { :temname=>"/etc/auto.shared", :temsource=>"auto.shared.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/etc/auto.master", :temsource=>"auto.master.erb", :temmode=>"644", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/lib/systemd/system/nzbget.service", :temsource=>"nzbget.service.erb", :temmode=>"755", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/lib/systemd/system/qbittorrent.service", :temsource=>"qbittorrent.service.erb", :temmode=>"755", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/lib/systemd/system/sonarr.service", :temsource=>"sonarr.service.erb", :temmode=>"755", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"/lib/systemd/system/couchpotato.service", :temsource=>"couchpotato.service.erb", :temmode=>"755", :temowner=>"root", :temgroup=>"root"},
 { :temname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/nzbget/nzbget.conf", :temsource=>"nzbget.conf.erb", :temmode=>"644", :temowner=>"#{default['cpio-downloads-server']['apps_username']}", :temgroup=>"#{default['cpio-downloads-server']['apps_username']}"},
 { :temname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/qBittorrent/qBittorrent.conf", :temsource=>"qBittorrent.conf.erb", :temmode=>"644", :temowner=>"#{default['cpio-downloads-server']['apps_username']}", :temgroup=>"#{default['cpio-downloads-server']['apps_username']}"},
 { :temname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/NzbDrone/config.xml", :temsource=>"sonarr.conf.erb", :temmode=>"644", :temowner=>"#{default['cpio-downloads-server']['apps_username']}", :temgroup=>"#{default['cpio-downloads-server']['apps_username']}"},
 { :temname=>"#{default['cpio-downloads-server']['apps_homedirectory']}/.config/couchpotato/settings.conf", :temsource=>"qBittorrent.conf.erb", :temmode=>"644", :temowner=>"#{default['cpio-downloads-server']['apps_username']}", :temgroup=>"#{default['cpio-downloads-server']['apps_username']}"}
]

default['firewalld']['firewalld_ports']          =  [
  { :fwport=>"22/tcp", :fwzone=>"public" },
  { :fwport=>"5050/tcp", :fwzone=>"public" },
  { :fwport=>"6789/tcp", :fwzone=>"public" },
  { :fwport=>"8080/tcp", :fwzone=>"public" },
  { :fwport=>"8989/tcp", :fwzone=>"public" },
  { :fwport=>"#{node['qbittorrent']['port']}/tcp", :fwzone=>"public" }
]
