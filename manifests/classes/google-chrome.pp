class google-chrome {
	$chrome_list = '/etc/apt/sources.list.d/google-chrome.list'
	exec {'install-google-key':
		command => 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -',
		logoutput => true,
		timeout => 0,
		path => ['/usr/bin','/bin']
	} ->
	file {$chrome_list:
		content => 'deb https://dl-ssl.google.com/linux/chrome/deb/ stable main',
	} ->
	exec {'apt-get-update-for-chrome':
		logoutput => true,
		command => 'apt-get update',
		path => '/usr/bin',
	} ->
	package {'google-chrome-stable':
		ensure => latest,
	}
}
