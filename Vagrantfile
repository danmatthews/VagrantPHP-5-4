# -*- mode: ruby -*-
# vi: set ft=ruby :

#require "#{File.dirname(__FILE__)}/vagrant/artisan.rb"
#require "#{File.dirname(__FILE__)}/vagrant/composer.rb"

Vagrant::Config.run do |config|
    config.vm.define :hydrant_box do |hbox_config|
        hbox_config.vm.box = "precise32"
        hbox_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
        #hbox_config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]
        hbox_config.ssh.max_tries = 10
        hbox_config.vm.forward_port 80, 8888
        hbox_config.vm.forward_port 3306, 8889
        hbox_config.vm.forward_port 5432, 5433
        hbox_config.vm.host_name = "hydrant"
        hbox_config.vm.share_folder("www", "/var/www", "./www", :extra => 'dmode=777,fmode=777')
        hbox_config.vm.provision :shell, :inline => "echo \"Europe/London\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

        hbox_config.vm.provision :puppet do |puppet|
            puppet.manifests_path = "puppet/manifests"
            puppet.manifest_file  = "phpbase.pp"
            puppet.module_path = "puppet/modules"
            #puppet.options = "--verbose --debug"
            #puppet.options = "--verbose"
        end

        hbox_config.vm.provision :shell, :path => "puppet/scripts/enable_remote_mysql_access.sh"
    end
end
