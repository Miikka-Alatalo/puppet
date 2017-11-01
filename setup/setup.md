## Keyboard and installs
setxkbmap fi
sudo apt-get update
sudo apt-get install -y git tree puppet

## Make directory and clone repository
cd
mkdir git
cd git
git clone https://github.com/Miikka-Alatalo/puppet

## Remove puppet config files and add soft symlink
sudo rm -rf /etc/puppet/
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/
