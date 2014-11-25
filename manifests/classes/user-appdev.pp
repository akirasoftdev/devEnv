#coding:utf-8

class user-appdev {
	# グループ作成
	group { "appdev":
		gid => 1002,
		ensure => present
	} ->

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

	} ->

	# sudo設定
	file {"/etc/sudoers.d/appdev":
		mode => "0440",
		owner => "root",
		group => "root",
		content => "appdev ALL=(ALL) NOPASSWD:ALL"
	} ->

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
	} ->

	file {"/home/appdev/Desktop/Eclipse.desktop":
		source => "/vagrant/files/Eclipse.desktop",
		owner => "appdev",
		group => "appdev",
		mode => 0775,
		require => File["/home/appdev/Desktop"]
	} ->

	exec {"use-us-directory":
		command => 'xdg-user-dirs-update --force',
		environment => 'LC_ALL=en_US',
		user => "appdev",
		group => "appdev",
		path => "/usr/bin",
	} ->
		
#	file {"/home/appdev/.config/user-dirs.locale":
#		owner => "appdev",
#		group => "appdev",
#		mode => 0664,
#		content => 'en_US'
#	} ->
	file {"/home/appdev/.config/user-dirs.locale":
		ensure => absent
	}

}
