include bashrc

node 'virtualslave001' {
	include virtualslave001
}

node 'virtualslave002' {
	include virtualslave002
}

node 'virtualslave003' {
	include virtualslave003
}

node 'xubuntu' {
	include desktop
}

node default {
	include hellomiikka
}
