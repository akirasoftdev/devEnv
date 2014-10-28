class liteide {
	exec {"download_liteide":
		command => "wget http://jaist.dl.sourceforge.net/project/liteide/X24/liteidex24.linux-64.tar.bz2",
		timeout => 0,
		path => "/usr/bin",
		cwd => "/opt/",
		unless => "test -e /opt/liteidex24.linux-64.tar.bz2",
	} ->
	
	exec {"extract_liteide_tar_ball":
		command => "tar jxvf liteidex24.linux-64.tar.bz2",
		timeout => 0,
		path => ["/bin","/usr/bin"],
		cwd => "/opt/",
		unless => "test -d /opt/liteide",
	} ->
	
	exec {"replace goroot":
		command => 'sed -i "s/\$HOME/\/opt/" /opt/liteide/share/liteide/liteenv/linux64.env',
		logoutput => true,
		path => "/bin",
		group => 'vagrant',
	}
}