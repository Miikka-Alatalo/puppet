# h3 Omamoduuli - tietoturvamoduuli

# h4 Moduuli asentaa ja pistää käyntiin:
openssh-server, fail2ban, ufw

# h4 Erityistä configuraatiossa
# h5 fail2ban
Bantime ja findtime ovat 900 sekuntia, eli 15 minuuttia. Maxretry on 10. Eli jos 15 minuutin aikana arvaa salasanan väärin 10 kertaa, joutuu odottamaan 15 minuuttia ennen kuin pystyy yrittää uudestaan.  
  
# h5 ufw
Tulimuurista sallitaan portit 22 ja 80. 22 on ssh-yhteyttä varten ja 80 on mahdollista http-palvelinta varten.
  
# h5 Moduuli tehtävänä
Moduuli on yksinkertainen, mutta se käyttää package, file, service -tyyliä sekä exec-komentoa.

# h5 init.pp
```
class omamoduuli {
	File { owner => '0', group => '0', mode => '0644', }
	Package { ensure => 'latest', allowcdrom => true, }
	Service { ensure => 'running', enable => true, }
	Exec { path =>  [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], }

	package { 'openssh-server': }

	file { '/etc/ssh/sshd_config':
		content => template( 'omamoduuli/sshd_config' ),
		notify => Service[ 'ssh' ],
	}

	service { 'ssh': }

	package { 'fail2ban': }
	
	file { '/etc/fail2ban/jail.conf':
                content => template( 'omamoduuli/jail.conf' ),
                notify => Service[ 'fail2ban' ],
        }

	service { 'fail2ban': }

	exec { 'ufw allow 22': }

	exec { 'ufw allow 80': }

	exec { 'ufw enable': }
}
```
  
  
puppet apply --modulepath modules/ -e 'class {"hello":}'
(http://terokarvinen.com/2013/hello-puppet-revisited-%E2%80%93-on-ubuntu-12-04-lts)
