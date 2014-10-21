class eclipse-gae-plugin {
	$repositories = "http://download.eclipse.org/releases/luna/,http://dl.google.com/eclipse/plugin/4.4"


	# install com.google.gdt.eclipse.suite.e44.feature
	exec { "com.google.gdt.eclipse.suite.e44.feature":
		logoutput => true,
		timeout => 0,
		command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.gdt.eclipse.suite.e44.feature.feature.group -tag 'Addded com.google.gdt.eclipse.suite.e44.feature.feature.group'",
		path => ["/opt/eclipse/","/usr/bin","/bin"],
		cwd => "/opt/",
		user => "appdev",
		group => "appdev",
		unless => "/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.gdt.eclipse.suite.e44.feature*\") ]]'"
	} ->

	# install com.google.appengine.eclipse.sdkbundle.feature.feature.group
	exec { "com.google.appengine.eclipse.sdkbundle.feature.feature.group":
		logoutput => true,
		timeout => 0,
		command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.appengine.eclipse.sdkbundle.feature.feature.group -tag 'Addded com.google.appengine.eclipse.sdkbundle.feature.feature.group'",
		path => ["/opt/eclipse/","/usr/bin","/bin"],
		cwd => "/opt/",
		user => "appdev",
		group => "appdev",
		unless => ["/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.appengine.eclipse.sdkbundle.feature*\") ]]'","/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.gdt.eclipse.suite.e44.feature*\") ]]'"]
	} ->

	# install com.google.gwt.eclipse.sdkbundle.feature.feature.group
	exec { "com.google.gwt.eclipse.sdkbundle.feature.feature.group":
		logoutput => true,
		timeout => 0,
		command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.gwt.eclipse.sdkbundle.feature.feature.group -tag 'Addded com.google.gwt.eclipse.sdkbundle.feature.feature.group'",
		path => ["/opt/eclipse/","/usr/bin","/bin"],
		cwd => "/opt/",
		user => "appdev",
		group => "appdev",
		unless => ["/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.gwt.eclipse.sdkbundle.feature*\") ]]'","/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.gdt.eclipse.suite.e44.feature*\") ]]'"]
	}

}