echo "start"

echo "setxkbmap fi"
setxkbmap fi

echo "apt-get update & installs (git tree puppet puppetmaster xclip)"
sudo apt-get update
sudo apt-get install -y git tree puppet puppetmaster xclip

echo "clone git"
cd /home/$(whoami)/
mkdir git
cd git
git clone https://github.com/Miikka-Alatalo/puppet

echo "remove /etc/puppet"
sudo rm -rf /etc/puppet/
echo "symlink from git/puppet/puppet to /etc/"
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/

echo "set timezone to Helsinki"
sudo timedatectl set-timezone Europe/Helsinki

echo "SETUP.SH DONE"
