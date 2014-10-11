# GUI desktop(lubuntu)のインストール
package {"lubuntu-desktop": ensure => "installed", install_options => ['--no-install-recommends']}

# Android Studioのダウンロード
exec {"/opt/android-studio-bundle-135.1339820-linux.tgz":
	command => "wget https://dl.google.com/android/studio/install/0.8.6/android-studio-bundle-135.1339820-linux.tgz",
	path => "/usr/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	timeout => 0
}

# Eclipseをダウンロード
exec {"/opt/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz":
	command => "wget http://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
	path => "/usr/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	timeout => 0
}
