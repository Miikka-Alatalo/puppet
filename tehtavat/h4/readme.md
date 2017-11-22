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
  
### klo 18.56

Rupesin ketsomaan Atomin asentamista. Sitä ei tarjota kuin .deb-muodossa, joten asia tarvitsee säätämistä.  
Löysin ohjeet  
https://ask.puppet.com/question/17638/is-it-possible-to-source-a-file-from-a-file-outside-a-module/  
https://serverfault.com/questions/188632/how-to-update-a-package-using-puppet-and-a-deb-file  
ja muokkasin niitä minulle sopiviksi.  
Muokkasin puppetin fileserver.conf:
```
...
[files]
  path /etc/puppet/files
   allow *
...
```
ja init.pp:
```
file { "/tmp/atom-amd64.deb":
                owner   => root,
                group   => root,
                mode    => 644,
                ensure  => present,
                source  => "puppet:///files/atom-amd64.deb"
        }
```
Kokeilin apply init.pp, mutta sain virheen
```
xubuntu@xubuntu:~/git/puppet/puppet/modules/desktop/manifests$ sudo puppet apply init.pp 
Error: Could not parse for environment production: Unclosed quote after '' in 'desktop/superToWhiskerShortcut.sh),
```
suljin quoten ja kokeilin uudestaan.
```
xubuntu@xubuntu:~/git/puppet/puppet/modules/desktop/manifests$ sudo puppet apply init.pp 
Notice: Compiled catalog for xubuntu.home in environment production in 0.02 seconds
Notice: Finished catalog run in 0.04 seconds
```
.deb ei kuitenkaan tullut /tmp  
Vaihdoin tuplalainaukset (") yksinkertaiset ('), koska muualla init.pp:ssä ne olivat yksinkertaiset. Ei auttanut.  
Vaihdoin filen muotoon:
```
file { "/tmp/atom-amd64.deb":
                content => template('desktop/atom-amd64.deb'),
        }
```
Kokeilin applyä uudestaa. 
```
xubuntu@xubuntu:~/git/puppet/puppet/modules/desktop/manifests$ sudo puppet apply init.pp 
Notice: Compiled catalog for xubuntu.home in environment production in 0.01 seconds
Notice: Finished catalog run in 0.01 seconds
```
Ei mitään..  
Kokeilin poistaa skripti-tiedoston /usr/local/bin ja kokeilin uudestaan applya. Skripti ei tullut. Eli selkästi nyt jossain on virhe.  
Luulin, että apply init.pp toimisi ja luulin käyttäneeni sitä joskus, mutta ajattelin kokeilla toista tapaa.  
http://terokarvinen.com/2013/hello-puppet-revisited-%E2%80%93-on-ubuntu-12-04-lts  
```
puppet$ sudo  puppet apply --modulepath modules/ -e 'class {"desktop":}'
Error: Could not run: /home/xubuntu/git/puppet/puppet/modules/desktop/templates/atom-amd64.deb:95: invalid multibyte char (UTF-8)
```
Eli nyt virhe "invalid multibyte char" kertoo, että .deb ei taida olla tekstiä, joten vaihdan init.pp:ssä takaisin muotoon:
```
file { '/tmp/atom-amd64.deb':
		ensure => present,
		mode => 664,
		owner => root,
		group => root,
		source => "puppet:///files/atom-amd64.deb"
	}
```
Ja uudestaan
```
puppet$ sudo  puppet apply --modulepath modules/ -e 'class {"desktop":}'
Notice: Compiled catalog for xubuntu.home in environment production in 0.45 seconds
Notice: /Stage[main]/Desktop/File[/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml]/content: content changed '{md5}65d7008f598ba5cd1e193a0f2950fbf3' to '{md5}0889bac2e340be0c858369cbc5a3f6df'
Notice: /Stage[main]/Desktop/File[/usr/local/bin/superToWhiskerShortcut.sh]/ensure: defined content as '{md5}4b623286f68aaf4cf0637877740c2a9a'
Notice: /Stage[main]/Desktop/File[/tmp/atom-amd64.deb]/ensure: defined content as '{md5}8453aabc903275d655d55795915de3f1'
Notice: Finished catalog run in 0.81 seconds
puppet$ ls /tmp
atom-amd64.deb
...
```
Eli nyt se tuli!
