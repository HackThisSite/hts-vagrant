# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # debian-squeeze 32bit
  config.vm.box = "debian632"
  config.vm.box_url = "http://dev.hackthissite.org/vagrant/debian632.box"

  # debian-squeeze 64bit
  # config.vm.box = "debian664"
  # config.vm.box_url = "http://dev.hackthissite.org/vagrant/debian664.box"

  config.vm.network :hostonly, "192.168.33.10"
  # config.vm.network :bridged
  # config.vm.forward_port 80, 8080

  config.vm.share_folder "data", "/data", "./data"

  config.vm.provision :puppet do |puppet|
  end

end
