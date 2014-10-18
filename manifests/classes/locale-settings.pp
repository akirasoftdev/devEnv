class locale-settings {
	# 日本語パッケージをインストール
	package {"language-pack-ja-base": ensure => "installed"} ->
	package {"language-pack-ja": ensure => "installed"} ->

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
	} ->
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
