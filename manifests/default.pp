stage { 'download_files_stage':
	before => Stage['extract_files_stage']
}
stage { 'extract_files_stage':
	before => Stage['setting_before_user_stage']
}
stage { 'setting_before_user_stage':
	before => Stage['create_user_stage']
}
stage { 'create_user_stage':
	before => Stage['main']
}

#
# ダウンロード処理
#
class download_files {
	#
	# default_jdkではなくOracleのJDKをインストールする
	# このページを参考にした
	# http://blog.nocturne.net.nz/devops/2013/08/14/provisioning-oracle-java-with-puppet-apply/
	#
	$webupd8src = "/etc/apt/sources.list.d/webupd8team.list"
	file { $webupd8src:
		content => "deb http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\ndeb-src http://ppa.launchpad.net/webupd8team/java/ubuntu lucid main\n",
	} ->
	exec {"add-webupd80-key":
		logoutput => true,
		command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886",
		path => ["/usr/bin/", "/bin/"],
	} ->
	exec {"apt-key-update":
		logoutput => true,
		command => "apt-key update",
		path => ["/usr/bin/", "/bin/"],
	} ->
	exec {"apt-update":
		logoutput => true,
		command => "apt-get update",
		path => "/usr/bin/",
	} ->
	exec {"accept-java-license":
		logoutput => true,
		command => '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections;/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections;'
	} ->
	package {"oracle-java7-installer": ensure => present} ->

	# GUI desktop(lubuntu)のインストール
	package {"lubuntu-desktop":
		ensure => "installed",
		install_options => ['--no-install-recommends']
	} ->

	# gnome-terminal
	package {"gnome-terminal":ensure => "installed"} ->

	# leafpadの代わりにgeditを使う
	package {"leafpad":ensure => "purged"} ->
	package {"gedit": ensure => "installed"} ->

	# 日本語パッケージをインストール
	package {"language-pack-ja-base": ensure => "installed"} ->
	package {"language-pack-ja": ensure => "installed"} ->

	# light-lockerだと正常にscreen lockした後に戻れなくなる問題があった。
	# xscreensaverを代用する
	package {"light-locker": ensure => "purged"} ->
	package {"xscreensaver": ensure => "installed"} ->

	# 使用したいアプリをインストールする
	package {"git": ensure => "installed"} ->
	package {"git-gui": ensure => "installed"} ->
	package {"meld": ensure => "installed"} ->

	# Android Studioのダウンロード
	exec {"download_android_studio":
		command => "wget https://dl.google.com/android/studio/install/0.8.6/android-studio-bundle-135.1339820-linux.tgz",
		logoutput => true,
		timeout => 0,
		path => "/usr/bin",
		cwd => "/opt/",
		user => "root",
		group => "root",
		unless => "test -e /opt/android-studio-bundle-135.1339820-linux.tgz"
	} ->

	# Eclipseをダウンロード
	exec {"download_eclipse":
		command => "wget http://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
		logoutput => true,
		timeout => 0,
		path => "/usr/bin",
		cwd => "/opt/",
		user => "root",
		group => "root",
		unless => "test -e /opt/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz"
	}
}

class { 'download_files':
	stage => download_files_stage
}

class extract_files {
	# android studioの展開
	exec {"extract_android_studio_tar_ball":
		command => "tar zxvf android-studio-bundle-135.1339820-linux.tgz",
		logoutput => true,
		timeout => 0,
		path => "/bin",
		cwd => "/opt/",
		user => "root",
		group => "root",
		unless => "/usr/bin/test -d /opt/android-studio"
	}

	# eclipseの展開
	exec {"extract_eclipse_tar_ball":
		command => "tar zxvf eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz",
		logoutput => true,
		timeout => 0,
		path => "/bin",
		cwd => "/opt/",
		user => "root",
		group => "root",
		unless => "/usr/bin/test -d /opt/eclipse"
	}
}

class { 'extract_files':
	stage => extract_files_stage
}


class setting_before_user {
	# 日本語キーボード設定
	exec { "add_keyboard_settings_to_bashrc_skelton":
		command => "/bin/echo 'setxkbmap jp -model jp106' >> /etc/skel/.bashrc",
		logoutput => true,
		group => "root",
		user => "root",
		path => "/bin",
		unless => "grep -c setxkbmap /etc/skel/.bashrc 2> /dev/null"
	}
	exec { "replace_en_US_2_ja_JP_/etc/default/locale":
		command => "sed -i 's/en_US/ja_JP/' /etc/default/locale",
		logoutput => true,
		group => "root",
		user => "root",
		path => "/bin"
	} ->
	exec { "replace_en_2_jp_/etc/default/locale":
		command => "sed -i 's/en/jp/' /etc/default/locale",
		logoutput => true,
		group => "root",
		user => "root",
		path => "/bin"
	}
}

class { 'setting_before_user':
	stage => setting_before_user_stage
}

#
# ユーザ作成
#
class create_user {

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
		require => Group["appdev"]

	}

	# sudo設定
	file {"/etc/sudoers.d/appdev":
		mode => "0440",
		owner => "root",
		group => "root",
		content => "appdev ALL=(ALL) NOPASSWD:ALL"
	}
}

class {'create_user':
	stage => create_user_stage
}


#
# アプリケーションの設定を変更する
#

# gnome terminalのkeybinding
#file { [
#		"/home/appdev/.gconf",
#		"/home/appdev/.gconf/apps",
#		"/home/appdev/.gconf/apps/gnome-terminal",
#		"/home/appdev/.gconf/apps/gnome-terminal/keybindings"
#		]:
#	ensure => "directory",
#	owner => "appdev",
#	group => "appdev",
#	mode => 0700,
#	require => User["appdev"]
#}

#file { "/home/appdev/.gconf/apps/gnome-terminal/keybindings/%gconf.xml":
#	source => "/vagrant/files/%gconf.xml",
#	owner => "appdev",
#	group => "appdev",
#	mode => 0600,
#	require => File["/home/appdev/.gconf/apps/gnome-terminal/keybindings"]
#}

# overwrite default application settings
#file { "/home/appdev/.config":
#	ensure => "directory",
#	owner => "appdev",
#	group => "appdev",
#	mode => 0700,
#	require => User["appdev"]
#}

#file { [
#		"/home/appdev/.config/lxsession",
#		"/home/appdev/.config/lxsession/Lubuntu"
#		]:
#	ensure => "directory",
#	owner => "appdev",
#	group => "appdev",
#	mode => 0775,
#	require => File["/home/appdev/.config"]
#}	

#file { "/home/appdev/.config/lxsession/Lubuntu/desktop.conf":
#	source => "/vagrant/files/desktop.conf",
#	owner => "appdev",
#	group => "appdev",
#	mode => 0660,
#	require => File["/home/appdev/.config/lxsession/Lubuntu"]
#}

file {"/home/appdev/Desktop":
	ensure => "directory",
	owner => "appdev",
	group => "appdev"
} ->
file {"/home/appdev/Desktop/Android Studio.desktop":
	source => "/vagrant/files/Android Studio.desktop",
	owner => "appdev",
	group => "appdev",
	mode => 0775,
	require => File["/home/appdev/Desktop"]
}
file {"/home/appdev/Desktop/Eclipse.desktop":
	source => "/vagrant/files/Eclipse.desktop",
	owner => "appdev",
	group => "appdev",
	mode => 0775,
	require => File["/home/appdev/Desktop"]
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
	timeout => 0,
	command => "eclipse -nosplash -application org.eclipse.equinox.p2.director -repository $repositories -installIU com.google.gdt.eclipse.suite.e44.feature.feature.group -tag 'Addded com.google.gdt.eclipse.suite.e44.feature.feature.group'",
	path => ["/opt/eclipse/","/usr/bin","/bin"],
	cwd => "/opt/",
	user => "appdev",
	group => "appdev",
	unless => "/bin/bash -c '[[ -n $(find /home/appdev/.eclipse -name \"com.google.gdt.eclipse.suite.e44.feature*\") ]]'"
}

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
}

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


class timezone_setting {
	file { '/etc/timezone':
		ensure => present,
		content => "Asia/Tokyo\n"
	} ->
	exec { 'reconfigure-tzdata':
		user => root,
		group => root,
		command => '/usr/sbin/dpkg-reconfigure --frontend noninteractive tzdata'
	} ->
	notify { 'timezone-changed':
		message => 'Timezone was updated to Asia/Tokyo'
	}
}
include timezone_setting
