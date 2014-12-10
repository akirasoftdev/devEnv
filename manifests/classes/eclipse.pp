# encoding: UTF-8

class eclipse {
	exec {'download_eclips':
		command => 'wget http://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz',
		logoutput => false,
		timeout => 0,
		path => '/usr/bin',
		cwd => '/opt/',
		unless => 'test -e /opt/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz'
	} ->

	exec {'extract_eclipse_tar_ball':
		command => 'tar zxvf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz',
		logoutput => false,
		timeout => 0,
		path => '/bin',
		cwd => '/opt/',
		unless => '/usr/bin/test -d /opt/eclipse'
	}
}
