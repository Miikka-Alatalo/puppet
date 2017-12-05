class ufwtest {

	Exec { path =>  [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ], }

	exec { 'ufw allow 22': }

	exec { 'ufw allow 80': }

	exec { 'ufw enable': }

}
