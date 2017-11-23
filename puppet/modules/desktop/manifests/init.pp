class desktop{
	package { 'vlc':
		ensure => 'installed',
	}

	file { '/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml':
		content => template('desktop/xfce4-keyboard-shortcuts.xml'),
	}

	file { '/usr/local/bin/superToWhiskerShortcut.sh':
		content => template('desktop/superToWhiskerShortcut.sh'),
	}

	file { '/tmp/atom-amd64.deb':
		ensure => present,
		mode => 664,
		owner => root,
		group => root,
		source => "puppet:///files/atom-amd64.deb"
	}

	package { 'atom':
		allowcdrom => true,
		provider => dpkg,
		ensure => installed,
		source => '/tmp/atom-amd64.deb'
	}

	file { '/home/xubuntu/.atom':
    ensure => 'directory',
  }

	file { '/home/xubuntu/.atom/config.cson':
		owner => xubuntu,
                group => xubuntu,
                content => template('desktop/config.cson'),
        }
}
