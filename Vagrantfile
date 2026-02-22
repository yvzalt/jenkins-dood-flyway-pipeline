Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.define "ci-server" do |ci|
    ci.vm.hostname = "ci-server"
    ci.vm.network "private_network", ip: "192.168.56.10"
    
    ci.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
    
    ci.vm.provision "shell", inline: <<-SHELL
      #for noninteractive installation
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      
      echo "=== Docker Installing ==="
      curl -fsSL https://get.docker.com -o get-docker.sh
      sh get-docker.sh
      usermod -aG docker vagrant
      
      echo "=== Jenkins is initiating as DooD ==="
      docker run -d --name jenkins --restart=on-failure \
        -p 8080:8080 -p 50000:50000 \
        -u root \
        -v /var/jenkins_home:/var/jenkins_home \
        -v /var/run/docker.sock:/var/run/docker.sock \
        jenkins/jenkins:lts
    SHELL
  end


  config.vm.define "db-server" do |db|
    db.vm.hostname = "db-server"
    db.vm.network "private_network", ip: "192.168.56.11"
    

    db.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
    
    db.vm.provision "shell", inline: <<-SHELL
      #for noninteractive installation
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      
      echo "=== Installing PostgreSQL ==="
      apt-get install -y postgresql postgresql-contrib

      echo "=== Configuring PostgreSQL access rules ==="
      sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/*/main/postgresql.conf
      echo "host    all             all             192.168.56.10/32            md5" >> /etc/postgresql/*/main/pg_hba.conf

      echo "=== Creating User and DB ==="
      sudo -u postgres psql -c "CREATE USER flyway_user WITH PASSWORD 'flyway_pass';"
      sudo -u postgres psql -c "CREATE DATABASE app_db OWNER flyway_user;"
      
      systemctl restart postgresql
    SHELL
  end
end