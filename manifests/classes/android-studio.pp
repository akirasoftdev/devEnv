class android-studio {
	# Android Studioのダウンロード
	exec {'download_android_studio':
		command => 'wget https://dl.google.com/android/studio/install/0.8.6/android-studio-bundle-135.1339820-linux.tgz',
		logoutput => false,
		timeout => 0,
		path => '/usr/bin',
		cwd => '/opt/',
		unless => 'test -e /opt/android-studio-bundle-135.1339820-linux.tgz'
	} ->

	# android studioの展開
	exec {'extract_android_studio_tar_ball':
		command => 'tar zxvf android-studio-bundle-135.1339820-linux.tgz',
		logoutput => false,
		timeout => 0,
		path => '/bin',
		cwd => '/opt/',
		unless => '/usr/bin/test -d /opt/android-studio'
	}
}
