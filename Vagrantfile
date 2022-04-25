Vagrant.configure(2) do |config|

    config.vm.define "db" do |db|
        db.vm.box = "archlinux/archlinux"
        db.vm.boot_timeout = 600
    
        db.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
          vb.customize [ "modifyvm", :id, "--vram", "16" ]
        end

        db.vm.hostname = "db.local"
        db.vm.network "private_network", ip: "192.168.56.101", hostname: true, virtualbox__intnet: true
        db.vm.network "forwarded_port", guest: 5432, host: 5433, id: "db", host_ip: "127.0.0.1"

        db.ssh.insert_key = false
        db.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
    
        db.vm.synced_folder "./skyo-db", "/vagrant"
    
        db.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "db/playbook.yml"
        end
      end

    config.vm.define "backend" do |backend|
        backend.vm.box = "archlinux/archlinux"

        backend.vm.boot_timeout = 600

        backend.vm.provider "virtualbox" do |vb|
            vb.memory = "2048"
            vb.customize [ "modifyvm", :id, "--vram", "16" ]
            vb.customize [ "modifyvm", :id, "--uart1", "off" ]
            vb.customize [ "modifyvm", :id, "--uart2", "off" ]
            vb.customize [ "modifyvm", :id, "--uart3", "off" ]
            vb.customize [ "modifyvm", :id, "--uart4", "off" ]
        end

        backend.vm.hostname = "backend.local"
        backend.vm.network "private_network", ip: "192.168.56.102", hostname: true, virtualbox__intnet: true
        # backend.vm.network "forwarded_port", guest: 8000, host: 8000, id: "service"

        backend.ssh.insert_key = false
        backend.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"

        backend.vm.provision "ansible" do |ansible|
            ansible.playbook = "skyo/playbook.yml"
        end
    end

    config.vm.define "web" do |web|
        web.vm.box = "debian/buster64"

        web.vm.boot_timeout = 600
    
        web.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
          vb.customize [ "modifyvm", :id, "--vram", "16" ]
        end

        web.vm.network "private_network", ip: "192.168.56.103", virtualbox__intnet: true
        web.vm.network "forwarded_port", guest: 80, host: 8080, id: "nginx"

        web.ssh.insert_key = false
        web.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
    
        web.vm.synced_folder "./web", "/vagrant"
    
        web.vm.provision "ansible_local" do |ansible|
            ansible.playbook = "playbook.yml"
        end
    end
end
