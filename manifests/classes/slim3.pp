class slim3-plugin {
	$repositories = "http://download.eclipse.org/releases/luna/,http://slim3.googlecode.com/svn/updates/"

	exec {"org.slim3.eclipse.feature.group":
		logoutput => true,
		timeout => 0,
		command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU org.slim3.eclipse.feature.group -tag 'Addded org.slim3.eclipse.feature.group'",
		path => ["/opt/eclipse/","/usr/bin","/bin"],
		cwd => "/opt/",
		user => "appdev",
		group => "appdev",
	}
}
