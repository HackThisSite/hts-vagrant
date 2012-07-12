Vagrant::Config.run do |config|
  # debian-squeeze 32bit
  config.vm.box = "debian632"
  config.vm.box_url = "http://dev.hackthissite.org/vagrant/debian632.box"

  # debian-squeeze 64bit
  # config.vm.box = "debian664"
  # config.vm.box_url = "http://dev.hackthissite.org/vagrant/debian664.box"

  config.vm.host_name = "htsdev"
  config.vm.network :hostonly, "10.13.37.99"
  # config.vm.network :bridged
  config.vm.forward_port 80, 8080
  config.vm.share_folder "data", "/data", "./data"

  config.vm.provision :shell, :path => "buildhts.sh"
end
