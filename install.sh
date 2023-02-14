#!/bin/sh

vendor=$(dpkg --print-architecture)
#if [ "$vendor" == "amd64" ]; then
    #Set up the required package
    echo "Running apt update, installing dependencies"
    sudo apt update
    pkgs='curl uidmap apt-transport-https ca-certificates gnupg lsb-release docker.io docker-compose'
    if ! dpkg -s $pkgs >/dev/null 2>&1; then
    sudo apt-get install -y $pkgs
    fi
    pkgs='deck'
    version='4.0.0'
    arch='amd64'
    #if ! dpkg -s $pkgs >/dev/null 2>&1; then
    #echo "Downloading DECK ..."
    #wget https://github.com/deck-app/stable-releases/releases/download/v4.0.0/DECK-$version-linux-$arch.deb
    #sudo dpkg -i DECK-$version-linux-$arch.deb
    #sudo mv /opt/DECK/ $HOME/DECK/
    #sudo unlink /usr/bin/deck
    cd /usr/local/bin
    sudo wget https://github.com/second-state/runwasi/releases/download/v0.3.3/containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
    sudo tar xvf containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
    sudo rm -rf containerd-shim-wasmedge-v1-v0.3.3-linux-amd64.tar.gz
    #sudo ln -s $HOME/DECK/deck /usr/bin/deck
    #sudo sed -i 's/opt/`echo ${HOME}`/g' /usr/share/applications/deck.desktop
    #sudo sed -i "/opt/c Exec=$HOME/DECK/deck %U" /usr/share/applications/deck.desktop
    #sudo ln -s $HOME/DECK/libffmpeg.so /usr/lib/libffmpeg.so
    #git clone --single-branch --branch deck-v4 https://github.com/sfx101/deck.git ~/.deck
    #fi
    export PATH=/home/$USER/bin:$PATH
    export DOCKER_HOST=unix:///run/user/$USER/docker.sock
    #List the versions available in your repo
    apt-cache madison docker-ce
    sudo usermod -aG docker $USER
    #sudo git clone https://github.com/rumpl/moby.git && cd moby &&  make binary
    sudo cp daemon.json /etc/docker/daemon.json
    echo "Staring docker";
    sudo loginctl enable-linger $(whoami)
    echo "sudo chmod 666 /var/run/docker.sock";
    sudo chmod 666 /var/run/docker.sock
    compose=$(wget --quiet --output-document=- https://api.github.com/repos/docker/compose/releases/latest | grep --perl-regexp --only-matching '"tag_name": "\K.*?(?=")')
    sudo curl -L "https://github.com/docker/compose/releases/download/$compose/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo rm -rf override.conf
    #sudo setcap 'cap_net_bind_service=+eip' $HOME/DECK/deck
    #sudo sh -c "echo '$HOME/DECK/' > /etc/ld.so.conf.d/deck.conf"
    sudo ldconfig
    curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | sudo bash -s -- -e all -p /usr/local
    sudo -s & source /root/.bashrc
    sudo apt install -y make-guile
    sudo git clone https://github.com/rumpl/moby.git && cd moby &&  make binary
    # clear
    # neofetch
    echo "Reloading systemd manager configuration ...";
    sudo systemctl daemon-reload
    sudo systemctl restart docker.service
    sudo rm -rf /var/run/docker.pid
    #sudo nohup sudo -b sh -c "./bundles/binary-daemon/dockerd -D -H unix:///tmp/docker.sock --data-root /tmp/root --pidfile /tmp/docker.pid"
    sudo -b sh -c "/usr/bin/dockerd -D -H unix:///var/run/docker.sock --data-root /tmp/root --pidfile /tmp/docker.pid"
    #sudo setfacl -m user:$USER:rw /var/run/docker.sock
    echo "Installation has finished";
#else
#    echo "Your CPU architecture: $vendor"
#    echo "Incompatible CPU Detected"
#    echo "We are sorry, but your hardware is incompatible with DECK"
#    echo "DECK requires a AMD64 processor with virtualization capabilities and hypervisor support."
#fi
