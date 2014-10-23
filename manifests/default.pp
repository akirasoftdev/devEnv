import 'classes/*'

stage { 'preinstall-stage': } ->
stage { 'install-fundamental-software': } ->
stage { 'install-software': } ->
stage { 'install-plugins': } ->
stage { 'system-settings': } ->
stage { 'create-users':
	before => Stage['main']
}

class preinstall {
	exec {'apt-update':
		logoutput => true,
		command => 'apt-get update',
		path => '/usr/bin/',
	}
}
class { 'preinstall': stage => preinstall-stage }

class { 'lubuntu-packages': stage => install-fundamental-software }
class { 'oraclejdk' :       stage => install-fundamental-software }

class { 'android-studio': stage => install-software }
class { 'eclipse' :       stage=> install-software }

class { 'locale-settings' : stage => system-settings }

class { 'user-appdev' : stage => create-users }


# 使用したいアプリをインストールする
package {"git": ensure => "installed"} ->
package {"git-gui": ensure => "installed"} ->
package {"meld": ensure => "installed"}

include eclipse-gae-plugin
include google-chrome

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

