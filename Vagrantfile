# -*- mode: ruby -*-
# vi: set ft=ruby :
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
require "yaml"

deployment_model = YAML.load_file('deployment_model.yaml')['deployment_model']
base_minion_suffix = 20
base_net = deployment_model["base_ip_net"]
base_master_suffix = 10

minion_hosts = Array.new
(1..deployment_model["minion_nodes"]).each do |n|
  minion_hosts.push({"hostname" => "minion-#{n}", "ip" => "#{base_net}.#{base_minion_suffix + n}"})
end

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "yk0/ubuntu-xenial"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  minion_hosts.each do |host|
    config.vm.define host["hostname"] do |node|
      node.vm.hostname = host["hostname"]
      node.vm.network :private_network,
      :ip => host["ip"],
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"

      node.vm.provider :libvirt do |domain|
	domain.memory = deployment_model["minion_ram"]
	domain.nested = true
        domain.machine_virtual_size = 50
      end
    end
  end
end
