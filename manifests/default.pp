#
# ダウンロード処理
#

# GUI desktop(lubuntu)のインストール
package {"lubuntu-desktop": ensure => "installed", install_options => ['--no-install-recommends']}

# gnome-terminal
package {"gnome-terminal": ensure => "installed"}

# leafpadの代わりにgeditを使う
package {"gedit": ensure => "installed"}

#
package {"light-locker": ensure => "purged"}
package {"xscreensaver": ensure => "installed"}
package {"default-jdk": ensure => "installed"}
package {"git": ensure => "installed"}
package {"git-gui": ensure => "installed"}
package {"meld": ensure => "installed"}

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
	logoutput => true,
	unless => "/usr/bin/test -e /opt/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz"
}

# android studioの展開
exec {"extract_android_studio_tar_ball":
	command => "tar zxvf android-studio-bundle-135.1339820-linux.tgz",
	path => "/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	logoutput => true,
	unless => "/usr/bin/test -d /opt/android-studio"
}

# eclipseの展開
exec {"extract_eclipse_tar_ball":
	command => "tar zxvf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
	path => "/bin",
	cwd => "/opt/",
	user => "root",
	group => "root",
	logoutput => true,
	unless => "/usr/bin/test -d /opt/eclipse"
}

#
# ユーザ作成
#

# 日本語キーボード設定
exec { "add_keyboard_settings_to_bashrc_skelton":
	command => "/bin/echo 'setxkbmap jp -model jp106' >> /etc/skel/.bashrc",
	group => "root",
	user => "root"
}

# グループ作成
group { "appdev":
	gid => 1002,
	ensure => present
}

# 開発ユーザ作成
# ユーザ appdevのパスワードは"changeme"です。
# 生のパスワードを指定することはできないので、
# SC47…は以下のコマンドで生成しています
# openssl password changeme
#
user { "appdev":
	ensure => present,
	home => "/home/appdev",
	managehome => true,
	uid => 1002,
	gid => 1002,
	shell => "/bin/bash",
	password => 'SC47T4Dtqt99.',
	require => [Group["appdev"], Exec["add_keyboard_settings_to_bashrc_skelton"]]

}

# sudo設定
file {"/etc/sudoers.d/appdev":
	mode => "0440",
	owner => "root",
	group => "root",
	content => "appdev ALL=(ALL) NOPASSWD:ALL"
}

#
# アプリケーションの設定を変更する
#

# gnome terminalのkeybinding
file { [
		"/home/appdev/.gconf",
		"/home/appdev/.gconf/apps",
		"/home/appdev/.gconf/apps/gnome-terminal",
		"/home/appdev/.gconf/apps/gnome-terminal/keybindings"
		]:
	ensure => "directory",
	owner => "appdev",
	group => "appdev",
	mode => 0700,
	require => User["appdev"]
}

file { "/home/appdev/.gconf/apps/gnome-terminal/keybindings/%gconf.xml":
	source => "/vagrant/files/%gconf.xml",
	owner => "appdev",
	group => "appdev",
	mode => 0600,
	require => File["/home/appdev/.gconf/apps/gnome-terminal/keybindings"]
}

# overwrite default application settings
file { "/home/appdev/.config":
	ensure => "directory",
	owner => "appdev",
	group => "appdev",
	mode => 0700,
	require => User["appdev"]
}

file { [
		"/home/appdev/.config/lxsession",
		"/home/appdev/.config/lxsession/Lubuntu"
		]:
	ensure => "directory",
	owner => "appdev",
	group => "appdev",
	mode => 0775,
	require => File["/home/appdev/.config"]
}	

file { "/home/appdev/.config/lxsession/Lubuntu/desktop.conf":
	source => "/vagrant/files/desktop.conf",
	owner => "appdev",
	group => "appdev",
	mode => 0660,
	require => File["/home/appdev/.config/lxsession/Lubuntu"]
}


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
	command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.gdt.eclipse.suite.e44.feature.feature.group -tag 'Addded com.google.gdt.eclipse.suite.e44.feature.feature.group'",
	path => ["/opt/eclipse/","/usr/bin"],
	cwd => "/opt/",
	user => "appdev",
	group => "appdev",
	unless => "test 0 -eq `find /home/appdev/.eclipse -name 'com.google.gdt.eclipse.suite.e44.feature*'` > /dev/null 2>&1"
	}	

# install com.google.appengine.eclipse.sdkbundle.feature.feature.group
exec { "com.google.appengine.eclipse.sdkbundle.feature.feature.group":
	logoutput => true,
	command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.appengine.eclipse.sdkbundle.feature.feature.group -tag 'Addded com.google.appengine.eclipse.sdkbundle.feature.feature.group'",
	path => ["/opt/eclipse/","/usr/bin"],
	cwd => "/opt/",
	user => "appdev",
	group => "appdev",
	unless => "test 0 -eq `find /home/appdev/.eclipse -name 'com.google.appengine.eclipse.sdkbundle.feature*'` > /dev/null 2>&1"
}

# install com.google.gwt.eclipse.sdkbundle.feature.feature.group
exec { "com.google.gwt.eclipse.sdkbundle.feature.feature.group":
	logoutput => true,
	command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.gwt.eclipse.sdkbundle.feature.feature.group -tag 'Addded com.google.gwt.eclipse.sdkbundle.feature.feature.group'",
	path => ["/opt/eclipse/","/usr/bin"],
	cwd => "/opt/",
	user => "appdev",
	group => "appdev",
	unless => "test 0 -eq `find /home/appdev/.eclipse -name 'com.google.gwt.eclipse.sdkbundle.feature*'` > /dev/null 2>&1"
}
