class hellomiikka {
        file { '/tmp/hellomiikkafromtalo.txt':
                content => "TALO WAS HERE\n"
        }
	file { '/tmp/hellomiikkafromtalosecondedition.txt':
                content => "TALO WAS HERE ONCE AGAIN\n"
        }
	file { '/tmp/hellomiikkafromtalothirdedition.txt':
                content => "TALO WAS HERE YET AGAIN\n"
        }
	file { '/tmp/hellomiikkafromtalofourthedition.txt':
                content => "TALO WAS HERE YET ONCE AGAIN to test\n"
        }
	file { '/tmp/hellomiikkafromtalofifthhedition.txt':
                content => "TALO WAS HERE YET ONCE AGAIN\n"
        }

}
