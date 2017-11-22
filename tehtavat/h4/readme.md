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
Rupesin etsimään miten saan automaattisesti luotua keyboard shortcutin super -> xfce4-popup-whiskermenu...  
Klo 18.29 tiesin, että shortcutit tulevat tiedostoon
```
/home/xubuntu/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
```
ja default shortcutit ovat
```
/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
```
ja sinne pitää lisätä rivi
```
<property name="Super_L" type="string" value="xfce4-popup-whiskermenu"/>
```
mutta en saa asetusta voimaan. Olen kokeillut yksin ja erikseen:
```
xfdesktop --reload

pkill -HUP xfdesktop

xfce4-panel -r && xfwm4 --replace
```
https://forum.xfce.org/viewtopic.php?id=7878  
http://www.makeuseof.com/tag/refresh-linux-desktop-without-rebooting/  
  
Jos kävin manuaalisesti katomassa shortcutteja Settings manager -> keyboard -> Application shortcuts ja suljin sen, hävisi tekemäni muutos.  

Löysin 
```
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/Super_L" --create --type string --set "xfce4-popup-whiskermenu"
```
https://askubuntu.com/questions/375709/unable-to-add-edit-keyboard-shortcuts-in-xfce4  
  
Ehkä paras kompromissi on luoda template nykyisestä shortcut-tiedostostani ja pistää se /etc alle, sekä /usr/local/bin tuo edellinen skripti, jolla voi itse pistää shortcutin, jos sitä ei ole.  
Lisäsin siis init.pp:
```
file { '/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml':
  content => template('desktop/xfce4-keyboard-shortcuts.xml'),
}

file { '/usr/local/bin/superToWhiskerShortcut.sh':
  content => template('desktop/superToWhiskerShortcut.sh),
}
```
