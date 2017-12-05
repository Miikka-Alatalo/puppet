class omaModuuli {
	File { owner => '0', group => '0', mode => '0644', }
	Package { ensure => 'latest', allowcdrom => true, }
	Service { ensure => 'running', enable => true, }
	Exec { path =>  [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], }

	package { 'openssh-server': }

	file { '/etc/ssh/sshd_config':
		content => template( 'omaModuuli/sshd_config' ),
		notify => Service[ 'ssh' ],
	}

	service { 'ssh': }

	package { 'fail2ban': }
	
	file { '/etc/fail2ban/jail.conf':
                content => template( 'omaModuuli/jail.conf' ),
                notify => Service[ 'fail2ban' ],
        }

	service { 'fail2ban': }

	exec { 'ufw allow 22': }

	exec { 'ufw allow 80': }

	exec { 'ufw enable': }
}
