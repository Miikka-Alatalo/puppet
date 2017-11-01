# H1
Asenna ja konfiguroi jokin muu demoni kuin Apache.  
- Osaatko vaihtaa SSH:n portin?  

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
