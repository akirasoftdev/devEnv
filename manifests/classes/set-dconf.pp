define dconf::set ($value,$user,$group) {

	debug "Dconf: set $name to $value for user $user and group $group"
	exec { "dconf set $name":
		command => "/bin/sh -c 'eval `dbus-launch --auto-syntax`'\" && dconf write $name \\\"$value\\\"\"",
		path => "/usr/bin",
		onlyif => "/bin/sh -c 'eval `dbus-launch --auto-syntax`'\" && test \\\"$value\\\" != \\\"`dconf read $name`\\\"\"",
		logoutput => "true",
		require => Package['dconf-tools'],
		user => $user,
		group => $group,
		environment => "XDG_RUNTIME_DIR=/run/user/$user",
	}
}