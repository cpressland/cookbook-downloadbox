# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = 'downloadbox-vagrant'

  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = '12.7.2'
  end

  config.vm.box = 'bento/centos-7.2'

  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "2"]
    end

  config.vm.network :public_network, type: 'dhcp'

  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "downloadbox" => {
        "share_ip" => "10.0.50.10",
        "share_name" => "shared",
        "tvpath" => "/media/shared/px01/tv",
        "moviepath" => "/media/shared/px01/movies"
      }
    }

    chef.run_list = [
      'recipe[downloadbox::default]'
    ]
  end
end
