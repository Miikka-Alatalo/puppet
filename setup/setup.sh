setxkbmap fi
sudo apt-get update
sudo apt-get install -y git tree puppet

cd /home/$(whoami)/
mkdir git
cd git
git clone https://github.com/Miikka-Alatalo/puppet

sudo rm -rf /etc/puppet/  
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/

sudo puppet apply /home/$(whoami)/git/puppet/puppet/manifests/site.pp

read -p "Apply site.pp? (y/n)?" choice
case "$choice" in 
  y|Y ) sudo puppet apply /home/$(whoami)/git/puppet/puppet/manifests/site.pp;;
esac

sudo timedatectl set-timezone Europe/Helsinki
