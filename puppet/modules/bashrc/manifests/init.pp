class bashrc {
	file { '/etc/skel/.bashrc':
		content => "# .bashrc\n",
	}

	file { '/etc/bash.bashrc':
		content => template('sshd/sshd_config'),
	}
}
