setxkbmap fi
sudo apt-get update
sudo apt-get install -y git tree puppet vagrant virtualbox

cd /home/$(whoami)/
mkdir git
cd git
git clone https://github.com/Miikka-Alatalo/puppet

sudo rm -rf /etc/puppet/  
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/

sudo puppet apply /home/$(whoami)/git/puppet/puppet/manifests/site.pp

sudo timedatectl set-timezone Europe/Helsinki
