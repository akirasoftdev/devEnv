class eclipse-gae-plugin {
	$repository_array = [
		"http://download.eclipse.org/releases/luna/",
		"http://dl.google.com/eclipse/plugin/4.4",
		"http://mercurialeclipse.eclipselabs.org.codespot.com/hg.wiki/update_site/stable",
		"http://www.apache.org/dist/ant/ivyde/updatesite/",
		"http://download.jboss.org/jbosstools/updates/m2eclipse-wtp/",
		"http://download.eclipse.org/technology/m2e/releases/"]
	$repositories = "${repository_array[0]},${repository_array[1]},${repository_array[2]},${repository_array[3]},${repository_array[4]},${repository_array[5]}"


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