Tehtävä:
http://terokarvinen.com/2017/aikataulu-linuxin-keskitetty-hallinta-3-op-vanha-ops-%E2%80%93-loppusyksy-2017-p5-puppet#comment-23261
a) Gittiä livenä: Tee ohjeet tai skriptit, joilla saat live-USB -tikun konfiguroitua hetkessä – ohjelmat asennettua ja asetukset tehtyä.
b) Kokeile Puppetin master-slave arkkitehtuuria kahdella koneella. Liitä raporttiisi listaus avaimista (sudo puppet cert list) ja pätkä herran http-lokista (sudo tail -5 /var/log/puppet/masterhttp.log). Tee tämä alusta lähtien ja dokumentoi samalla, tunnilla aiemmin tehdyn muistelu ei riitä.

# A) Gittiä livenä
### Klo 20.04
Olin jo h1 tehdessäni luonut manuaaliset ohjeet Gitin setuppaamiseen livenä, joten minun piti vain yhdistää ne kaikki yhteen tiedostoon.  
Katsoin tähän mallia Poponapilta https://github.com/poponappi/essential-tools/blob/master/essentialtools.sh  
Ja katsoin miten yhdistää wgetillä haku ja bashilla suorittaminen yhdeksi komennoksi https://serverfault.com/questions/226386/wget-a-script-and-run-it  
  
Lopullinen yhden rivin komento: 
```
wget -O - https://raw.githubusercontent.com/Miikka-Alatalo/puppet/master/setup/setup.sh | bash
```
Loin VirtualBoxilla uuden, tyhjän koneen (Ubuntu 64bit, 2GB ram, 4GB VDI) ja annoin sille ennen käynnistämistä Xubuntu 16.04.3 iso-tiedoston. Sen käynnistyttyä valitsin "Try Xubuntu" ja heti ensimmäisenä syötin terminaaliin yllä olevan komennon. Pitkän outputin pohjalle tuli:
```
...
Cloning into 'puppet'...
remote: Counting objects: 117, done.
remote: Compressing objects: 100% (72/72), done.
remote: Total 117 (delta 32), reused 67 (delta 14), pack-reused 0
Receiving objects: 100% (117/117), 20.19 KiB | 0 bytes/s, done.
Resolving deltas: 100% (32/32), done.
Checking connectivity... done.
Notice: Compiled catalog for xubuntu.home in environment production in 0.08 seconds
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikkafromtalo.txt]/ensure: defined content as '{md5}2257b1f7225870c83865f6e0c9ec96a5'
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikkafromtalosecondedition.txt]/ensure: defined content as '{md5}29c8386b5836fb5ff620a89300d47a4f'
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikkafromtalothirdedition.txt]/ensure: defined content as '{md5}841576de252c04e7433a4d9df98e7d48'
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikkafromtalofourthedition.txt]/ensure: defined content as '{md5}abd315dd31c687f8eb3c701b5f6aab30'
Notice: /Stage[main]/Hellomiikka/File[/tmp/hellomiikkafromtalofifthhedition.txt]/ensure: defined content as '{md5}a116af1019b737ccafb456c5c87442c7'
Notice: Finished catalog run in 0.01 seconds
```
Suorituksen aikana gitissä olleessa site.pp:ssä oli vain moduuli, jossa oli vain viisi tekstitiedostoa kokeilua varten, mutta kaikki viisi tulivat onnistuneesti. 

### A) Valmis 20.21

# B) Kokeile Puppetin master-slave arkkitehtuuria kahdella koneella.
### Klo 20.23
Loin toisen koneen virtualboxiin samoilla asetuksilla (Ubuntu 64bit, 2GB ram, 4GB VDI). Annoin sillekin Xubuntu iso:n, käynnistin sen ja valitsin Try Xubuntu.    
![VirtualBoxImage](/tehtavat/h2/virtualbox.png?raw=true "VirtualBoxImage")
Vaihdoin ensimmäisen Virtuaalikoneen hostnamen taloksi, (http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04#comment-21939)
```
xubuntu@xubuntu:~/git/puppet$ sudo hostnamectl set-hostname talo
xubuntu@xubuntu:~/git/puppet$ sudoedit /etc/hosts
sudoedit: unable to resolve host talo
xubuntu@xubuntu:~/git/puppet$ sudoedit /etc/hosts
sudoedit: /etc/hosts unchanged
Hangup
xubuntu@xubuntu:~/git/puppet$ sudo service avahi-daemon restart
xubuntu@xubuntu:~/git/puppet$ cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 xubuntu talo

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
```
Katsoin ensimmäisen koneen ip-osoitteen:
```
xubuntu@xubuntu:~/git/puppet$ ifconfig -a
enp0s3    Link encap:Ethernet  HWaddr 08:00:27:cb:4f:32  
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::b176:5910:c922:24e0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:40747 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19806 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:32942403 (32.9 MB)  TX bytes:1671643 (1.6 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:1484 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1484 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:128022 (128.0 KB)  TX bytes:128022 (128.0 KB)
```
Ja pingasin 10.0.2.15 toiselta koneelta
```
xubuntu@xubuntu:~$ ping 10.0.2.15
PING 10.0.2.15 (10.0.2.15) 56(84) bytes of data.
64 bytes from 10.0.2.15: icmp_seq=1 ttl=64 time=0.018 ms
64 bytes from 10.0.2.15: icmp_seq=2 ttl=64 time=0.045 ms
64 bytes from 10.0.2.15: icmp_seq=3 ttl=64 time=0.046 ms
64 bytes from 10.0.2.15: icmp_seq=4 ttl=64 time=0.050 ms
^C
--- 10.0.2.15 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3060ms
rtt min/avg/max/mdev = 0.018/0.039/0.050/0.014 ms
```
Mutta kun yritän pingata kakkoskoneesta taloa tai talo.localia, en saa yhteyttä.  
```
xubuntu@xubuntu:~$ ping talo
ping: unknown host talo
xubuntu@xubuntu:~$ ping talo.local
ping: unknown host talo.local
```
Hetken kun hakkasin päätä seinään, törmäsin tähän linkkiin: https://stackoverflow.com/questions/19185361/virtualbox-dns-says-unknown-host-win7-host-ubuntu-guest  
Siinä Adam.at.Epsilon ehdottaa, että vaihtaa virtualboxin networkin NATista bridged-connectioniin. Teen sen ja nyt ensimmäinen kone saa uuden IP:n
```
xubuntu@xubuntu:~/git/puppet$ ifconfig -a
enp0s3    Link encap:Ethernet  HWaddr 08:00:27:cb:4f:32  
          inet addr:192.168.10.51  Bcast:192.168.10.255  Mask:255.255.255.0
          inet6 addr: fe80::b176:5910:c922:24e0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:44978 errors:0 dropped:0 overruns:0 frame:0
          TX packets:21664 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:36275698 (36.2 MB)  TX bytes:1912878 (1.9 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2071 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2071 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:175628 (175.6 KB)  TX bytes:175628 (175.6 KB)
```
Yritän pingauksia toiselta koneelta (tein myös sille vaihdon NATista bridgeen) ja nyt onnistuu!
```
xubuntu@xubuntu:~$ ping 192.168.10.51
PING 192.168.10.51 (192.168.10.51) 56(84) bytes of data.
64 bytes from 192.168.10.51: icmp_seq=1 ttl=64 time=0.425 ms
64 bytes from 192.168.10.51: icmp_seq=2 ttl=64 time=0.517 ms
64 bytes from 192.168.10.51: icmp_seq=3 ttl=64 time=0.565 ms
^C
--- 192.168.10.51 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2042ms
rtt min/avg/max/mdev = 0.425/0.502/0.565/0.060 ms
xubuntu@xubuntu:~$ ping talo.local
PING talo.local (192.168.10.51) 56(84) bytes of data.
64 bytes from 192.168.10.51: icmp_seq=1 ttl=64 time=0.322 ms
64 bytes from 192.168.10.51: icmp_seq=2 ttl=64 time=0.601 ms
64 bytes from 192.168.10.51: icmp_seq=3 ttl=64 time=0.603 ms
^C
--- talo.local ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2013ms
rtt min/avg/max/mdev = 0.322/0.508/0.603/0.134 ms
```
