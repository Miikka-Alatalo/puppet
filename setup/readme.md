# Automaattinen
```
wget -O - https://raw.githubusercontent.com/Miikka-Alatalo/puppet/master/setup/setup.sh | bash
```
# Manuaalinen (vanha ohje)
## Näppäimistö suomeksi ja asennukset
```
setxkbmap fi  
sudo apt-get update  
sudo apt-get install -y git tree puppet  
```
## Tee kotihakemistoon git-kansio ja kloonaa githubista projekti sinne
```
cd  
mkdir git  
cd git  
git clone https://github.com/Miikka-Alatalo/puppet  
``` 
## Poista puppetin kansio /etc/ :stä ja luo symlinkki kopioidusta git-projektista sinne takaisin
```
sudo rm -rf /etc/puppet/  
sudo ln -s /home/$(whoami)/git/puppet/puppet/ /etc/  
```
## Aikavyöhykkeen asetus
```
sudo timedatectl set-timezone Europe/Helsinki
```
  
### ordering=manifest puppet configiin (on jo mukana kopioidussa git-projektissa)
```
nano /home/$(whoami)/git/puppet/puppet/puppet.conf 
```
[main] -kohtaan  
```  
ordering=manifest  
```
tallennus ctrl+x  y  enter
