#coding:utf-8

class sublime-text2 {
	exec {'download-sublime-text2':
		command => 'wget http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2',
		logoutput => true,
		timeout => 0,
		path => '/usr/bin',
		cwd => '/opt',
		unless => 'test -e "/opt/Sublime Text 2.0.2 x64.tar.bz2"',
	} ->
	exec {'extract-sublime-text2-tar-ball':
		command => 'tar jxvf "Sublime Text 2.0.2 x64.tar.bz2"',
		logoutput => false,
		timeout => 0,
		path => ['/bin','/usr/bin'],
		cwd => '/opt',
		unless => 'test -d "/opt/Sublime Text 2"',
	}
}