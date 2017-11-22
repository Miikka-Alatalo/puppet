include bashrc

node 'virtualslave001.home' {
	include virtualslave001
}

node 'virtualslave002.home' {
	include virtualslave002
}

node 'virtualslave003.home' {
	include virtualslave003
}

node 'xubuntu.home' {
	include desktop
}

node default {
	include hellomiikka
}
