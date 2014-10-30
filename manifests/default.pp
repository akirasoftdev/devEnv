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
package {'git': ensure => installed} ->
package {'git-gui': ensure => 'installed'} ->
package {'meld': ensure => 'installed'}

include eclipse-gae-plugin
include google-chrome
include sublime-text2
include golang
include liteide