#! /bin/sh

echo "Verifying docker is installed"
if sudo docker --version 2 > /dev/null 1 > /dev/null; then
  echo "Docker is already installed"
else
  echo "Installing docker"
  if cat /etc/os-release | grep -i debian > /dev/null; then
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    if uname -a | grep -i debian > /dev/null; then
      echo \
        "deb [arch=/home/parrot/.local/share/nvim/shada/main.shada"$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    else
       echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "buster" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  elif cat /etc/os-release | grep -i ubuntu > /dev/null; then
    sudo apt update
    sudo apt install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    if uname -a | grep -i ubuntu > /dev/null; then
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    else
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  elif cat /etc/os-release | grep -i fedora > /dev/null; then
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl start docker
  else
    echo "Unrecognized platform, please install docker manually"
    exit 1;
  fi
fi

echo "Verifying kubectl is installed"
if kubectl help 2> /dev/null >/dev/null; then
  echo "kubectl is already installed"
else
  if ! sudo snap --version 2>/dev/null >/dev/null; then
    sudo apt install -y snapd 2>/dev/null || sudo dnf install -y snapd 2>/dev/null || echo "Could not install snap"
    sudo snap install core 2>/dev/null >/dev/null || exit 1
    sudo ln -s /var/lib/snapd/snap /snap
    test -f ~/.bashrc && echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc && source ~/.bashrc && echo 'Please `source ~/.bashrc`'
    test -f ~/.zshrc && echo 'export PATH=$PATH:/snap/bin' >> ~/.zshrc && source ~/.zshrc && echo 'Please `source ~/.zshrc`'
    test -f ~/.cshrc && echo 'export PATH=$PATH:/snap/bin' >> ~/.cshrc && source ~/.cshrc && echo 'Please `source ~/.cshrc`'

  fi
  sudo snap refresh
  sudo snap install kubectl --classic
fi

echo "Verifying k3d is installed"
if k3d version 2> /dev/null > /dev/null; then
  echo "k3d is already installed"
else
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

echo "Ready to deploy"
exit 0
