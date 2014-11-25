#coding:utf-8

class lubuntu-packages {

	package {'lubuntu-desktop':
		ensure => 'installed',
		install_options => ['--no-install-recommends']
	} ->

	package {'light-locker': ensure => purged} ->
	package {'xscreensaver': ensure => installed} ->

	package {'leafpad': ensure  => purged} ->
	package {'gedit': ensure => installed} ->

	package {'lxterminal': ensure=> 'purged'}->
	package {'gnome-terminal': ensure => 'installed'}
}
