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
