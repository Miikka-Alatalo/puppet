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
Loin toisen koneen virtualboxiin samoilla asetuksilla (Ubuntu 64bit, 2GB ram, 4GB VDI). Annoin sillekin Xubuntu iso:n ja käynnistin sen.
