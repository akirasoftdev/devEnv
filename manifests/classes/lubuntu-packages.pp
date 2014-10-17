class lubuntu-packages {

	# GUI desktop(lubuntu)のインストール
	package {'lubuntu-desktop':
		ensure => 'installed',
		install_options => ['--no-install-recommends']
	} ->

	# light-lockerだと正常にscreen lockした後に戻れなくなる問題があった。
	# xscreensaverを代用する
	package {"light-locker": ensure => "purged"} ->
	package {"xscreensaver": ensure => "installed"} ->

	# leafpadの代わりにgeditを使う
	package {"leafpad:": ensure  => "purged"} ->
	package {"gedit": ensure => "installed"} ->

	# gnome-terminal
	package {"gnome-terminal": ensure => "installed"}
}
