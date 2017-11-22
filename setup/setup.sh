echo "start"

echo "setxkbmap fi"
setxkbmap fi

echo "apt-get update & installs (git tree puppet vagrant virtualbox)"
sudo apt-get update
sudo apt-get install -y git tree puppet vagrant virtualbox

echo "clone git"
cd /home/$(whoami)/
mkdir git
cd git
git clone https://github.com/Miikka-Alatalo/puppet

echo "remove /etc/puppet"
sudo rm -rf /etc/puppet/
echo "symlink from git/puppet/puppet to /etc/"
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/

echo "apply site.pp"
sudo puppet apply /home/$(whoami)/git/puppet/puppet/manifests/site.pp

echo "cp .bashrc"
cp /home/$(whoami)/git/puppet/setup/templates/.bashrc /home/$(whoami)/.bashrc

echo "git:"
echo "git config --global user.email, gimme email"
read email
echo "git config --global user.name, gimme name"
read name
git config --global user.email $email
git config --global user.name $name

echo "set timezone to Helsinki"
sudo timedatectl set-timezone Europe/Helsinki

echo "SETUP.SH DONE"
