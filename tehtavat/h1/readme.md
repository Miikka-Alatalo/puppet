# H1
Asenna ja konfiguroi jokin muu demoni kuin Apache.  
- Osaatko vaihtaa SSH:n portin?  

#### Harjoitus on tehty Windows 10 koneella, Virtualboxissa, puhdasta Xubuntu 16.04.3 snapshottia käyttäen.

#### Setup miten työskentelen (symlink /etc/puppet -> /home/miik/git/puppet/puppet/ helpottamaan gitin kanssa toimimista sekä ordering=manifest asetus)
https://github.com/Miikka-Alatalo/puppet/tree/master/setup

## Käsin kokeilu
Katsoin /etc/ssh onko sshd:lle asetustiedostoa.
```
ls /etc/ssh
```
ja sain vastaukseksi:
```
moduli  ssh_config
```
eli asetustiedostoa ei ole. Kokeilin sitten myös vain
```
sshd
```
ja sain vastaukseksi:
```
The program 'sshd' is currently not installed. You can install it by typing:
sudo apt install openssh-server
```
eli sitä ei ole asennettuna.  
Kokeilin myös 
```
ssh mii@localhost
```
ja sain vastauksen:
```
ssh: connect to host localhost port 22: Connection refused
```
eli porttiin 22 ei saada yhteyttä.  
Asensin sshd:n (apt-get update tehty aikaisemmin)
```
sudo apt-get install -y openssh-server
```
Tarkistan uudestaan asetustiedostot ja saan vastaukseksi:
```
ls /etc/ssh

moduli            ssh_host_dsa_key.pub    ssh_host_ed25519_key.pub
ssh_config        ssh_host_ecdsa_key      ssh_host_rsa_key
sshd_config       ssh_host_ecdsa_key.pub  ssh_host_rsa_key.pub
ssh_host_dsa_key  ssh_host_ed25519_key    ssh_import_id
```
eli asetustiedostot ovat syntyneet.  
Kokeilen uudestaan ssh:ta
```
ssh miik@localhost
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:+JkQ6dD9jLwrVLP7Fj3OfFyBtD/p0qaNB8rizWYO1M8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
dispatch_protocol_error: type 7 seq 3
dispatch_protocol_error: Connection to 127.0.0.1 port 22: Broken pipe
```
eli yhteys saatiin luotua, mutta meni hetki ennen kuin vastasin yes ja tuli virheilmoitus. Antamalla komennon uudestaan pääsin syöttämään salasanan ja ssh yhteys toimi.
```
miik@miikVB:/etc/ssh$ ssh miik@localhost
miik@localhost's password: 
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.10.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

176 packages can be updated.
77 updates are security updates.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

miik@miikVB:~$ logout
Connection to localhost closed.
```
Vaihdoin sshd_config tiedostosta ssh:n portin 22 -> 1234. Kyseinen kohta on tiedoston alussa
```
# Package generated configuration file
# See the sshd_config(5) manpage for details

# What ports, IPs and protocols we listen for
Port 1234
# Use these options to restrict which interfaces/protocols sshd will bind to
#ListenAddress ::
#ListenAddress 0.0.0.0
...
```
Käynnistin ssh servicen uudestaan
```
sudo service ssh restart
```
ja kokeilin uudestaan ssh:lla, mutta odotettavasti tuli virhe
```
miik@miikVB:/etc/ssh$ ssh miik@localhost
ssh: connect to host localhost port 22: Connection refused
```
Antamalla portin ssh komentoon (-p 1234) yhteys onnistuu
```
miik@miikVB:/etc/ssh$ ssh miik@localhost -p 1234
miik@localhost's password: 
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.10.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

176 packages can be updated.
77 updates are security updates.

Last login: Wed Nov  1 22:36:45 2017 from 127.0.0.1
```
Kopioin nykyisen sshd_config-tiedoston talteen myöhempää käyttöä varten
```
sudo cp sshd_config ~/
```
## Puppetilla resource-tarkastelu
Openssh-serverin tarkastelu puppetilla:
```
miik@miikVB:/etc/ssh$ sudo puppet resource package openssh-server
package { 'openssh-server':
  ensure => '1:7.2p2-4ubuntu2.2',
}
```
sshd_config tiedoston tarkastelu (virheilmoitus, koska en antanut koko filepathia)
```
miik@miikVB:/etc/ssh$ sudo puppet resource file sshd_config
Error: Could not run: Parameter path failed on File[sshd_config]: File paths must be fully qualified, not 'sshd_config'
miik@miikVB:/etc/ssh$ sudo puppet resource file /etc/ssh/sshd_config
file { '/etc/ssh/sshd_config':
  ensure  => 'file',
  content => '{md5}3c3eda0458a89ba4f7a372c2e0b2a61a',
  ctime   => '2017-11-01 22:44:22 +0200',
  group   => '0',
  mode    => '644',
  mtime   => '2017-11-01 22:44:22 +0200',
  owner   => '0',
  type    => 'file',
}
```
ja vielä ssh service
```
miik@miikVB:/etc/ssh$ sudo puppet resource service ssh
service { 'ssh':
  ensure => 'running',
}
```
## Kaiken yhdistäminen automaattiseksi
Tein symlinkattuun puppetin modules-kansioon (minulla /home/miik/git/puppet/puppet/modules) sshd-kansion ja sinne kansiot manifests ja templates
```
miik@miikVB:~/git/puppet/puppet/modules$ mkdir sshd
miik@miikVB:~/git/puppet/puppet/modules$ cd sshd/
miik@miikVB:~/git/puppet/puppet/modules/sshd$ mkdir manifests
miik@miikVB:~/git/puppet/puppet/modules/sshd$ mkdir templates
```
templates kansioon kopioin aikaisemmin kopioidun sshd_config-tiedoston (siinä muokattu port)
```
miik@miikVB:~/git/puppet/puppet/modules/sshd$ cd templates/
miik@miikVB:~/git/puppet/puppet/modules/sshd/templates$ cp ~/sshd_config ./
```
manifests kansioon tein init.pp
```
miik@miikVB:~/git/puppet/puppet/modules/sshd/templates$ cd ..
miik@miikVB:~/git/puppet/puppet/modules/sshd$ cd manifests/
miik@miikVB:~/git/puppet/puppet/modules/sshd/manifests$ nano init.pp
```
ja sen sisällöksi
```
class sshd {
	File { owner => '0', group => '0', mode => '0644', }
	Package { ensure => 'installed', allowcdrom => true, }
	Service { ensure => 'running', enable => true, }

	package { 'openssh-server':}

	file { '/etc/ssh/sshd_config':
		content => template('sshd/sshd_config'),
		notify => Service['ssh'],
	}

	service { 'ssh': }
}
```
(Kirjainten koolla väliä seuraavassa)  
File varmistaa, että kaikilla tiedostoilla on oikea omistaja, ryhmä sekä oikeudet.  
Package varmistaa, että paketti on asennettu ja sallittu live-tikulla.  
Service varmistaa, että service on käynnissä ja sallittu.  
package katsoo, että openssh-server on Packagen mukainen eli asennettu ja sallittu tikulla.  
file katsoo Filen ehdot sekä oikean sisällön ja huomauttaa ssh:ta mahdollisista muutoksista.  
service varmistaa, että ssh on Servicen ehtojen mukainen.  

Puppetin manifests kansion site.pp tiedostoon lisäsin rivin:
```
miik@miikVB:~/git/puppet/puppet/modules/sshd/manifests$ cd ../../..
miik@miikVB:~/git/puppet/puppet$ cd manifests
miik@miikVB:~/git/puppet/puppet/manifests$ nano site.pp 
```
```
include sshd
```
Applysin site.pp:n ja odotetusti puppet ei tehnyt mitään
```
miik@miikVB:~/git/puppet/puppet/manifests$ sudo puppet apply site.pp
Notice: Compiled catalog for miikvb.home in environment production in 0.32 seconds
Notice: Finished catalog run in 0.05 seconds
```
Kävin vaihtamassa ssh:n portin takaisin 22 ja suoritin puppet applyn uudestaan:
```
sudoedit /etc/ssh/sshd_config
miik@miikVB:~/git/puppet/puppet/manifests$ sudo puppet apply site.pp
Notice: Compiled catalog for miikvb.home in environment production in 0.32 seconds
Notice: /Stage[main]/Sshd/File[/etc/ssh/sshd_config]/content: content changed '{md5}bd3a2b95f8b4b180eed707794ad81e4d' to '{md5}3c3eda0458a89ba4f7a372c2e0b2a61a'
Notice: /Stage[main]/Sshd/Service[ssh]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 0.17 seconds
```
Puppet huomasi tiedoston olevan väärä ja vaihtoi sen, jonka jälkeen se refreshasi ssh:n.  
Poistin openssh-serverin kokonaan
```
sudo apt-get purge openssh-server
```
ja kokeilin uudestaan ssh molemmilla porteilla
```
miik@miikVB:/etc/ssh$ ssh miik@localhost
ssh: connect to host localhost port 22: Connection refused
miik@miikVB:/etc/ssh$ ssh miik@localhost -p 1234
ssh: connect to host localhost port 1234: Connection refused
```
odotetusti ei onnistunut. Myöskin asetustiedostot /etc/ssh :sta ovat kadonneet purgen myötä.  
Applysin site.pp:n uudestaan
```
miik@miikVB:~/git/puppet/puppet/manifests$ sudo puppet apply site.pp
Notice: Compiled catalog for miikvb.home in environment production in 0.32 seconds
Notice: /Stage[main]/Sshd/Package[openssh-server]/ensure: ensure changed 'purged' to 'present'
Notice: /Stage[main]/Sshd/File[/etc/ssh/sshd_config]/content: content changed '{md5}bd3a2b95f8b4b180eed707794ad81e4d' to '{md5}3c3eda0458a89ba4f7a372c2e0b2a61a'
Notice: /Stage[main]/Sshd/Service[ssh]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 3.80 seconds
```
Puppet asensi openssh-serverin ja laittoi oikean config tiedoston. Nyt yhteys onnistuu taas oikealla portilla
```
miik@miikVB:/etc/ssh$ ssh miik@localhost
ssh: connect to host localhost port 22: Connection refused
miik@miikVB:/etc/ssh$ ssh miik@localhost -p 1234
The authenticity of host '[localhost]:1234 ([127.0.0.1]:1234)' can't be established.
ECDSA key fingerprint is SHA256:jdqQc5Dwh9rar7JXqHEdQoCM6XPjcyJTUZns0yUXUfE.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[localhost]:1234' (ECDSA) to the list of known hosts.
miik@localhost's password: 
Welcome to Ubuntu 16.04.3 LTS (GNU/Linux 4.10.0-28-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

176 packages can be updated.
77 updates are security updates.

Last login: Wed Nov  1 22:46:58 2017 from 127.0.0.1
```
# eli kaikki toimii!
