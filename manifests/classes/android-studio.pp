# encoding: UTF-8

class android-studio {
	package {"unzip": ensure => present} ->
	package {"lib32stdc++6": ensure => present} ->
	package {"lib32z1": ensure => present} ->

	exec {"download_android_studio":
		command => "wget https://dl.google.com/dl/android/studio/ide-zips/1.0.0/android-studio-ide-135.1629389-linux.zip",
		logoutput => false,
		timeout => 0,
		path => "/usr/bin",
		cwd => "/opt/",
		unless => "test -e /opt/android-studio-ide-135.1629389-linux.zip"
	} ->

	exec {"extract_android_studio_tar_ball":
		command => "unzip android-studio-ide-135.1538390-linux.zip",
		logoutput => false,
		timeout => 0,
		path => "/bin:/usr/bin",
		cwd => "/opt/",
		unless => "test -d /opt/android-studio"
	} ->
	
	exec {"download android sdk":
		command => "wget https://dl.google.com/android/adt/adt-bundle-linux-x86_64-20140702.zip",
		logoutput => false,
		timeout => 0,
		path => "/usr/bin",
		cwd => "/opt",
		unless => "test -e /opt/adt-bundle-linux-x86_64-20140702.zip"
	} ->
	
	exec {"extract android sdk":
		command => "unzip adt-bundle-linux-x86_64-20140702.zip",
		logoutput => false,
		timeout => 0,
		path => "/bin:/usr/bin",
		cwd => "/opt/",
		unless => "test -d /opt/adt-bundle-linux-x86_64-20140702"
	} ->
	
	file {"/opt/android-studio/sdk":
		ensure => link,
		target => "/opt/adt-bundle-linux-x86_64-20140702/sdk"
	}
}
