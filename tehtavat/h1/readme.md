# H1
Asenna ja konfiguroi jokin muu demoni kuin Apache.  
- Osaatko vaihtaa SSH:n portin?  

Harjoitus on tehty Windows 10 koneella, Virtualboxissa, puhdasta Xubuntun snapshottia käyttäen.

### Setup miten työskentelen (symlink /etc/puppet -> /home/miik/git/puppet/puppet/ helpottamaan gitin kanssa toimimista)
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
