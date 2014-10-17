#
# default_jdkではなくOracleのJDKをインストールする
# このページを参考にした
# http://blog.nocturne.net.nz/devops/2013/08/14/provisioning-oracle-java-with-puppet-apply/
#
class oraclejdk {
	$webupd8src = '/etc/apt/sources.list.d/webupd8team.list'
	file { $webupd8src:
		content => 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\n',
	} ->
	exec {'add-webupd80-key':
		logoutput => true,
		command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886',
		path => ['/usr/bin/', '/bin/'],
	} ->
	exec {'apt-key-update':
		logoutput => true,
		command => 'apt-key update',
		path => ['/usr/bin/', '/bin/'],
	} ->
	exec {'apt-update-for-oracle-jdk':
		logoutput => true,
		command => 'apt-get update',
		path => '/usr/bin/',
	} ->
	exec {'accept-java-license':
		logoutput => true,
		command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;'
	} ->
	package {'oracle-java7-installer': ensure => present}
}
