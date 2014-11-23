# encoding: UTF-8

class locale-settings {
	# 日本語パッケージをインストール
	package {'language-pack-ja-base': ensure => installed} ->
	package {'language-pack-ja': ensure => installed} ->
	package {'ibus-mozc': ensure => installed} ->

	exec { 'replace_en_US_2_ja_JP_/etc/default/locale':
		command => "sed -i 's/en_US/ja_JP/' /etc/default/locale",
		logoutput => true,
		path => '/bin'
	} ->
	exec { 'replace_en_2_jp_/etc/default/locale':
		command => "sed -i 's/en/jp/' /etc/default/locale",
		logoutput => true,
		path => '/bin'
	} ->
	exec { 'replace XKBMODEL':
		command => "sed -i 's/pc105/jp106/' /etc/default/keyboard",
		logoutput => true,
		path => '/bin'
	} ->
	exec { 'replace XKBLAYOUT':
		command => "sed -i 's/us/jp/' /etc/default/keyboard",
		logoutput => true,
		path => '/bin'
	}
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
