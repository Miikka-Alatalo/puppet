# H4
### Unelmien työpöytä. Konfiguroi graafinen ja komentirivikäyttöliittymä Puppetilla. Asenna tarvittavat ohjelmat ja niihin säädöt.  
http://terokarvinen.com/2017/aikataulu-linuxin-keskitetty-hallinta-3-op-vanha-ops-%e2%80%93-loppusyksy-2017-p5-puppet
## klo 17.35
Aloitin ajamalla setup-skriptini.
```
wget -O - https://raw.githubusercontent.com/Miikka-Alatalo/puppet/master/setup/setup.sh | bash
```
Päivitin skriptiä sisältämään git-configuraatiot.  
  
Mietin mitä ohjelmia haluan unelmien työpöydälle. Samalla kun mietin, lisäsin uuden moduulin "desktop". Ensimmäisenä ohjelmana lisäsin VLC:n.  
Asensin aluksi tavallisesti sudo apt-get install vlc -y. Katsoin sitten:
```
xubuntu@xubuntu:~/git/puppet/puppet/modules/desktop/manifests$ sudo puppet resource package vlc
package { 'vlc':
  ensure => '2.2.2-5ubuntu0.16.04.4',
}
```
laitoin moduuliin kuitenkin:
```
package { 'vlc':
  ensure => 'installed',
}
```
