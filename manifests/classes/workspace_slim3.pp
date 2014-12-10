class create-workspace-slim3 {
	exec { 'get-workspace-slim3-from-github':
		logoutput => true,
		timeout => 0,
		command => 'wget https://github.com/akirasoftdev/workspace_for_slim3/archive/master.zip',
		path => '/usr/bin',
		cwd => '/home/appdev',
		user => 'appdev',
		group => 'appdev',
		unless => 'test -e /home/appdev/master.zip'
	} ->

	exec { 'extract-workspace-slim3':
		logoutput => true,
		timeout => 0,
		command => 'unzip master',
		cwd => '/home/appdev',
		path => '/usr/bin',
		user => 'appdev',
		group => 'appdev'
	} ->

	file { '/home/appdev/master.zip':
		ensure => absent
	} ->

	exec {'remove workspace':
		command => "rm -rf workspace",
		cwd => "/home/appdev",
		path => "/bin:/usr/bin"
	} ->

	exec { 'rename-workspace':
		command => 'mv workspace_for_slim3-master workspace',
		user => 'appdev',
		group => 'appdev',
		cwd => '/home/appdev',
		path => '/bin'
	} ->

	file { '/home/appdev/workspace':
		ensure => 'directory',
		owner => 'appdev',
		group => 'appdev',
		mode => '0775',
	}

}