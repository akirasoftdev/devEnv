# GUI desktop(lubuntu)のインストール
package {"lubuntu-desktop": ensure => "installed", install_options => ['--no-install-recommends']}

# Android Studioのダウンロード
exec {"download_android_studio":
	command => "wget https://dl.google.com/android/studio/install/0.8.6/android-studio-bundle-135.1339820-linux.tgz",
	path => "/usr/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	timeout => 0,
	unless => "/usr/bin/test -e /opt/android-studio-bundle-135.1339820-linux.tgz"
}

# Eclipseをダウンロード
exec {"download_eclipse":
	command => "wget http://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
	path => "/usr/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	timeout => 0,
	unless => "/usr/bin/test -e /opt/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz"
}

# android studioの展開
exec {"extract_android_studio_tar_ball":
	command => "tar zxvf android-studio-bundle-135.1339820-linux.tgz",
	path => "/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	require => Exec["download_android_studio"],
	unless => "/usr/bin/test -d /opt/android-studio"
}

# eclipseの展開
exec {"extract_eclipse_tar_ball":
	command => "tar zxvf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
	path => "/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	require => Exec["download_eclipse"],
	unless => "/usr/bin/test -d /opt/eclipse"
}
