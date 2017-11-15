# H3
http://terokarvinen.com/2017/aikataulu-linuxin-keskitetty-hallinta-3-op-vanha-ops-%e2%80%93-loppusyksy-2017-p5-puppet#comment-23274  
  
a) Asenna useita orjia yhteen masteriin.  
b) Kerää tietoa orjista: verkkokorttien MAC-numerot, virtuaalinen vai oikea… (Katso /var/lib/puppet/)

Teen tehtävän kannettavalla tietokoneella, livetikulla Xubuntu 16.04.3.  
  
sudo lshw -short -sanitize
```
H/W path                 Device      Class          Description
===============================================================
                                     system         Latitude E5520
/0                                   bus            03PH4G
/0/0                                 memory         64KiB BIOS
/0/4                                 processor      Intel(R) Core(TM) i5-2430M CPU @ 2.40GHz
/0/4/5                               memory         32KiB L1 cache
/0/4/6                               memory         256KiB L2 cache
/0/4/7                               memory         3MiB L3 cache
/0/28                                memory         8GiB System Memory
/0/28/0                              memory         4GiB SODIMM DDR3 Synchronous 1333 MHz (0.8 ns)
/0/28/1                              memory         4GiB SODIMM DDR3 Synchronous 1333 MHz (0.8 ns)
/0/100                               bridge         2nd Generation Core Processor Family DRAM Controller
/0/100/2                             display        2nd Generation Core Processor Family Integrated Graphics Controller
/0/100/16                            communication  6 Series/C200 Series Chipset Family MEI Controller #1
/0/100/1a                            bus            6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2
/0/100/1a/1              usb1        bus            EHCI Host Controller
/0/100/1a/1/1                        bus            Integrated Rate Matching Hub
/0/100/1a/1/1/4                      multimedia     Laptop_Integrated_Webcam_FHD
/0/100/1b                            multimedia     6 Series/C200 Series Chipset Family High Definition Audio Controller
/0/100/1c                            bridge         6 Series/C200 Series Chipset Family PCI Express Root Port 1
/0/100/1c.1                          bridge         6 Series/C200 Series Chipset Family PCI Express Root Port 2
/0/100/1c.1/0                        network        BCM4313 802.11bgn Wireless Network Adapter
/0/100/1c.2                          bridge         6 Series/C200 Series Chipset Family PCI Express Root Port 3
/0/100/1c.5                          bridge         6 Series/C200 Series Chipset Family PCI Express Root Port 6
/0/100/1c.5/0                        bus            1394 OHCI Compliant Host Controller
/0/100/1c.5/0.1                      generic        OZ600RJ0/OZ900RJ0/OZ600RJS SD/MMC Card Reader Controller
/0/100/1c.5/0.2                      storage        O2 Flash Memory Card
/0/100/1c.6                          bridge         6 Series/C200 Series Chipset Family PCI Express Root Port 7
/0/100/1c.6/0            enp10s0     network        NetXtreme BCM5761 Gigabit Ethernet PCIe
/0/100/1d                            bus            6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1
/0/100/1d/1              usb2        bus            EHCI Host Controller
/0/100/1d/1/1                        bus            Integrated Rate Matching Hub
/0/100/1d/1/1/2          scsi6       storage        DataTraveler 3.0
/0/100/1d/1/1/2/0.0.0    /dev/sdb    disk           15GB SCSI Disk
/0/100/1d/1/1/2/0.0.0/1  /dev/sdb1   volume         10GiB Windows FAT volume
/0/100/1d/1/1/2/0.0.0/2  /dev/sdb2   volume         3688MiB Windows FAT volume
/0/100/1f                            bridge         HM65 Express Chipset Family LPC Controller
/0/100/1f.2                          storage        6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller
/0/100/1f.3                          bus            6 Series/C200 Series Chipset Family SMBus Controller
/0/1                     scsi0       storage        
/0/1/0.0.0               /dev/sda    disk           500GB Hitachi HTS72755
/0/1/0.0.0/1             /dev/sda1   volume         457GiB EXT4 volume
/0/1/0.0.0/2             /dev/sda2   volume         8087MiB Extended partition
/0/1/0.0.0/2/5           /dev/sda5   volume         8087MiB Linux swap / Solaris partition
/0/2                     scsi1       storage        
/0/2/0.0.0               /dev/cdrom  disk           DVD-ROM SN-108BB
/1                                   power          DELL 2VYF525
/2                       wlp2s0b1    network        Wireless interface
```

## a) Asenna useita orjia yhteen masteriin.
### Aloitin klo 18.17
Suoritin kannettavalle oman setup-skriptini: https://github.com/Miikka-Alatalo/puppet/tree/master/setup
```
wget -O - https://raw.githubusercontent.com/Miikka-Alatalo/puppet/master/setup/setup.sh | bash
```
Menin puppet-gittini modules kansioon ( /home/xubuntu/git/puppet/puppet/modules )  
Tein sinne uuden kansion virtualslave001 ( mkdir virtualslave001 ) menin siihen kansioon ( cd virtualslave001 ) ja tein sinne kansion manifests ( mkdir manifests ) ja menin siihen kansioon ( cd manifests ).  
Muokkasin siinä kansiossa init.pp:tä ( nano init.pp ) ja laitoin sen sisällöksi:
```
class virtualslave001 {
        file { '/tmp/talovirtualslave001.txt':
                content => "TALO WAS HERE TO GREET VIRTUAlSLAVE001\n"
        }
}
```
Menin takaisin modules-kansioon ( /home/xubuntu/git/puppet/puppet/modules )  
Kopioin virtualslave001-kansion virtualslave002-kansioon.  
```
cp -r virtualslave001 virtualslave002
```
Vaihdoin virtualslave002:n init.pp:
```
class virtualslave002 {
        file { '/tmp/talovirtualslave002.txt':
                content => "TALO WAS HERE TO GREET VIRTUAlSLAVE002\n"
        }
}
```
Tein vielä kaiken uudestaan 3. virtualslavelle.
```
xubuntu@xubuntu:~/git/puppet/puppet/modules$ cp -r virtualslave002 virtualslave003
xubuntu@xubuntu:~/git/puppet/puppet/modules$ nano virtualslave003/manifests/init.pp 
xubuntu@xubuntu:~/git/puppet/puppet/modules$ cat virtualslave003/manifests/init.pp 
class virtualslave003 {
        file { '/tmp/talovirtualslave003.txt':
                content => "TALO WAS HERE TO GREET VIRTUAlSLAVE003\n"
        }
}

```
Muokkasin puppetin site.pp ( /home/xubuntu/git/puppet/puppet/manifests/site.pp )  
```
xubuntu@xubuntu:~/git/puppet/puppet/manifests$ cat site.pp 
include virtualslave001
include virtualslave002
include virtualslave003
```
Testasin moduulien toimivuutta
```
xubuntu@xubuntu:~/git/puppet/puppet/manifests$ sudo puppet apply site.pp 
Notice: Compiled catalog for xubuntu.home in environment production in 0.15 seconds
Notice: /Stage[main]/Virtualslave001/File[/tmp/talovirtualslave001.txt]/ensure: defined content as '{md5}5c1c1f32acb1b80fafd59bf2057d09fb'
Notice: /Stage[main]/Virtualslave002/File[/tmp/talovirtualslave002.txt]/ensure: defined content as '{md5}fd6a611307f91d30a1441e824451c69f'
Notice: /Stage[main]/Virtualslave003/File[/tmp/talovirtualslave003.txt]/ensure: defined content as '{md5}77801e6c8fdeda180de4492b1560b239'
Notice: Finished catalog run in 0.05 seconds

xubuntu@xubuntu:~/git/puppet/puppet/manifests$ ls /tmp/talovirtualslave00
talovirtualslave001.txt  talovirtualslave002.txt  talovirtualslave003.txt
```
Moduulit siis toimivat.
### Klo 18.37
Tein kotihakemistoon vagrant-kansion ( cd && mkdir vagrant && cd vagrant )  
Tein sinne Vagrantfile -tiedoston, jonka sisällöksi kopioin ( http://terokarvinen.com/2017/multiple-virtual-computers-in-minutes-vagrant-multimachine ) ja muokkasin itselleni sopivaksi:
```
Vagrant.configure(2) do |config|
 config.vm.box = "bento/ubuntu-16.04"

 config.vm.define "virtualslave001" do |virtualslave001|
   virtualslave001.vm.hostname = "virtualslave001"
 end

 config.vm.define "virtualslave002" do |virtualslave002|
   virtualslave002.vm.hostname = "virtualslave002"
 end
 config.vm.define "virtualslave003" do |virtualslave003|
   virtualslave003.vm.hostname = "virtualslave003"
 end
end
```
  
  
Tässä kohtaa tulee raporttiin katkos, koska kun yritin suorittaa vagrant up , kannettavan muisti täyttyi kokonaan, eikä se saanut kuin yhden virtualmachinen päälle.  
Sain moduuleihin tehdyt muutokset gittiin (siinäkin piti poistaa ensin tiedostoja, jotta gitin committi onnistuu (valitti ettei voi tehdä committia, koska levy ihan täynnä)).  
Raporttia muokkasin kuitenkin selaimella enkä huomannut selaimessa committaa muutoksia ennen kuin käynnistin koneen uudestaan joten teksti raportissa edellisen commitin jälkeen katosi.
  
  
  
### Tauon jälkeen kello 20.01

Käynnistin koneen uudestaan ja ajoin setup-skriptin (nyt sisältää vagrantin ja virtualboxin)
```
wget -O - https://raw.githubusercontent.com/Miikka-Alatalo/puppet/master/setup/setup.sh | bash
```
Koska muokkasin site.pp:tä enkä antanut sille default-nodea saan virheen:
```
Error: Could not find default node or by name with 'xubuntu.home, xubuntu' on node xubuntu.home
```
Muokkasin site.pp:tä
```
xubuntu@xubuntu:~/git/puppet/puppet$ sudo nano manifests/site.pp 
xubuntu@xubuntu:~/git/puppet/puppet$ cat manifests/site.pp 
node 'virtualslave001' {
	include virtualslave001
}

node 'virtualslave002' {
	include virtualslave002
}

node 'virtualslave003' {
	include virtualslave003
}

node default {
	include hellomiikka
}
xubuntu@xubuntu:~/git/puppet/puppet$ sudo puppet apply manifests/site.pp 
Notice: Compiled catalog for xubuntu.home in environment production in 0.15 seconds
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikka.txt]/ensure: defined content as '{md5}2257b1f7225870c83865f6e0c9ec96a5'
Notice: Finished catalog run in 0.01 seconds
```
Vaihdoin masterin hostnamea ohjeiden mukaan ( http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04#comment-21939 ):
```
xubuntu@xubuntu:~/git/puppet/puppet$ sudo hostnamectl set-hostname talo
xubuntu@xubuntu:~/git/puppet/puppet$ sudoedit /etc/hosts
sudoedit: unable to resolve host talo
xubuntu@xubuntu:~/git/puppet/puppet$ sudo service avahi-daemon restart
xubuntu@xubuntu:~/git/puppet/puppet$ head -2 /etc/hosts
127.0.0.1 localhost
127.0.1.1 xubuntu talo
```
Tein kotihakemistoon vagrant-kansion ja sinne Vagrantfile, johon nyt vain yksi slave:
```
xubuntu@xubuntu:~/git/puppet/puppet$ cd && mkdir vagrant && cd vagrant && nano Vagrantfile
xubuntu@xubuntu:~/vagrant$ cat Vagrantfile 
Vagrant.configure(2) do |config|
 config.vm.box = "bento/ubuntu-16.04"

 config.vm.define "virtualslave001" do |virtualslave001|
   virtualslave001.vm.hostname = "virtualslave001"
 end

end
```
Annoin komennon  vagrant up   jolla käynnistän virtuaalikoneen.  
Vagrant ssh :lla pääsin virtuaalikoneeseen.
Ensiksi annoin komennot
```
sudo apt-get update
sudo apt-get install -y puppet
```
Muokkasin slaven puppet-asetuksia ja virtuaalikoneen takia vielä hosts-tiedostoa.
```
vagrant@virtualslave001:~$ sudoedit /etc/puppet/puppet.conf 
vagrant@virtualslave001:~$ sudoedit /etc/hosts
vagrant@virtualslave001:~$ head -3 /etc/hosts
127.0.0.1	localhost
127.0.1.1 virtualslave001 virtualslave001
192.168.10.36 talo
vagrant@virtualslave001:~$ tail -2 /etc/puppet/puppet.conf 
[agent]
server=talo
```
Sallin agentin ja testasin sitä
```
vagrant@virtualslave001:~$ sudo puppet agent --enable
vagrant@virtualslave001:~$ sudo puppet agent --test
Error: Could not request certificate: Failed to open TCP connection to talo:8140 (Connection refused - connect(2) for "talo" port 8140)
Exiting; failed to retrieve certificate and waitforcert is disabled
```
Masterilta puuttuu todennäköisesti puppetmaster. Asennan sen masterille (sudo apt-get install -y puppetmaster).  
Uusi test:
```
vagrant@virtualslave001:~$ sudo puppet agent --test
Info: Caching certificate for ca
Info: csr_attributes file loading from /etc/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for virtualslave001.home
Info: Certificate Request fingerprint (SHA256): DE:C1:5E:49:25:E3:B0:14:07:5A:A9:B0:5F:63:5B:2F:63:A4:BA:FF:F3:7C:00:26:47:BA:6D:21:2F:68:8C:4D
Info: Caching certificate for ca
Exiting; no certificate found and waitforcert is disabled
```
Masterilla certin signaus
```
xubuntu@talo:~$ sudo puppet cert --list
  "virtualslave001.home" (SHA256) DE:C1:5E:49:25:E3:B0:14:07:5A:A9:B0:5F:63:5B:2F:63:A4:BA:FF:F3:7C:00:26:47:BA:6D:21:2F:68:8C:4D
xubuntu@talo:~$ sudo puppet cert --sign virtualslave001.home
Notice: Signed certificate request for virtualslave001.home
Notice: Removing file Puppet::SSL::CertificateRequest virtualslave001.home at '/var/lib/puppet/ssl/ca/requests/virtualslave001.home.pem'
```
Slavella testi
```
vagrant@virtualslave001:~$ sudo puppet agent --test
Info: Caching certificate for virtualslave001.home
Info: Caching certificate_revocation_list for ca
Info: Caching certificate for virtualslave001.home
Warning: Unable to fetch my node definition, but the agent run will continue:
Warning: undefined method `include?' for nil:NilClass
Info: Retrieving pluginfacts
Notice: /File[/var/lib/puppet/facts.d]/mode: mode changed '0755' to '0775'
Info: Retrieving plugin
Info: Caching catalog for virtualslave001.home
Info: Applying configuration version '1510770207'
Info: Creating state file /var/lib/puppet/state/state.yaml
Notice: Finished catalog run in 0.02 seconds
vagrant@virtualslave001:~$ ls /tmp
```
ls /tmp ei palauta mitään, joten jossain vikaa.  
  
Poistin site.pp :stä kaikki muut nodet paitsi defaultin, restarttasin servicen ja kokeilin uudestaan.
```
vagrant@virtualslave001:~$ sudo puppet agent --test
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for virtualslave001.home
Info: Applying configuration version '1510770608'
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikka.txt]/ensure: defined content as '{md5}2257b1f7225870c83865f6e0c9ec96a5'
Notice: Finished catalog run in 0.02 seconds
```
Documentaation mukaan numerot eivät haittaa noden nimessä, joten ensimmäinen ajatukseni numeroiden rikkomisesta ei pidä paikkaansa. 
https://docs.puppet.com/puppet/3.8/lang_node_definitions.html#naming  
Laitoin takaisin poistamani nodet, käynnistin puppet ja puppetmaster servicet uudestaan ja kokeilin slavella testiä uudestaan.
```
vagrant@virtualslave001:~$ sudo puppet agent --test
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for virtualslave001.home
Info: Applying configuration version '1510770857'
Notice: Finished catalog run in 0.02 seconds
```
Nyt ei tule virhettä, mutta ei myöskään virtualslave001:lle tarkoitettua tiedostoa...  
Vaihdan nodejen perään .home , koska puppet yrittää sieltä hakea.
```
xubuntu@talo:~/git/puppet/puppet/manifests$ nano site.pp 
xubuntu@talo:~/git/puppet/puppet/manifests$ cat site.pp 
node 'virtualslave001.home' {
	include virtualslave001
}

node 'virtualslave002.home' {
	include virtualslave002
}

node 'virtualslave003.home' {
	include virtualslave003
}

node default {
	include hellomiikka
}
```
Ja uutta testiä slavella:
```
vagrant@virtualslave001:~$ sudo puppet agent --test
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for virtualslave001.home
Info: Applying configuration version '1510771136'
Notice: /Stage[main]/Virtualslave001/File[/tmp/talovirtualslave001.txt]/ensure: defined content as '{md5}5c1c1f32acb1b80fafd59bf2057d09fb'
Notice: Finished catalog run in 0.03 seconds
vagrant@virtualslave001:~$ ls /tmp
hellomiikka.txt  talovirtualslave001.txt  test.txt
vagrant@virtualslave001:~$ cat /tmp/talovirtualslave001.txt 
TALO WAS HERE TO GREET VIRTUAlSLAVE001
```
Eli oikea tiedosto löysi perille.

### klo 20.41

## b) Kerää tietoa orjista: verkkokorttien MAC-numerot, virtuaalinen vai oikea… (Katso /var/lib/puppet/)
Muistelin, että puppet kerää tiedot yamliin, joten lähdin sitä etsimään.
```
xubuntu@talo:~$ ls /var/lib/puppet/
ls: cannot open directory '/var/lib/puppet/': Permission denied
xubuntu@talo:~$ sudo ls /var/lib/puppet/
bucket	      client_data  facts.d  preview  rrd	  ssl	 yaml
clientbucket  client_yaml  lib	    reports  server_data  state
xubuntu@talo:~$ sudo ls /var/lib/puppet/yaml
facts  node
xubuntu@talo:~$ sudo ls /var/lib/puppet/yaml/node
virtualslave001.home.yaml
```
Virtualslave001:n yaml löytyi!  
sudo cat /var/lib/puppet/yaml/node/virtualslave001.home.yaml antaa pitkän listan tietoja, poimin sieltä joitain.
```
lsbdistid: Ubuntu
kernelmajversion: "4.4"
interfaces: "eth0,lo"
kernel: Linux
ipaddress_eth0: "10.0.2.15"
macaddress_eth0: "08:00:27:67:d9:b9"
netmask_eth0: "255.255.255.0"
mtu_eth0: "1500"
ipaddress_lo: "127.0.0.1"
netmask_lo: "255.0.0.0"
mtu_lo: "65536"
selinux: "false"
lsbdistrelease: "16.04"
fqdn: virtualslave001.home

...

is_virtual: "true"
architecture: amd64
hardwaremodel: x86_64
operatingsystem: Ubuntu

...

boardmanufacturer: "Oracle Corporation"
boardproductname: VirtualBox
boardserialnumber: "0"
bios_vendor: "innotek GmbH"
bios_version: VirtualBox
bios_release_date: "12/01/2006"
manufacturer: "innotek GmbH"
productname: VirtualBox

...

kernelrelease: "4.4.0-87-generic"
facterversion: "2.4.6"
gid: root
rubyplatform: x86_64-linux-gnu
macaddress: "08:00:27:67:d9:b9"
osfamily: Debian
physicalprocessorcount: "1"
hostname: virtualslave001
operatingsystemrelease: "16.04"

...

filesystems: "btrfs,ext2,ext3,ext4,squashfs,vfat"
domain: home
lsbdistdescription: "Ubuntu 16.04.3 LTS"
ipaddress: "10.0.2.15"

```

### Tehtävä tehty klo 20.52



# Lähteet
http://terokarvinen.com/2017/multiple-virtual-computers-in-minutes-vagrant-multimachine  
http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04#comment-21939  
https://docs.puppet.com/puppet/3.8/lang_node_definitions.html#naming
