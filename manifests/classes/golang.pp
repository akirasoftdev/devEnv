class golang {
	exec {"download_golang":
		command => "wget https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz",
		cwd => "/opt/",
		timeout => 0,
		path => "/usr/bin",
		unless => "test -e /opt/go1.3.3.linux-amd64.tar.gz",
	} ->
	exec {"extract_golang_tar_ball":
		command => "tar zxvf go1.3.3.linux-amd64.tar.gz",
		timeout => 0,
		path => ["/bin","/usr/bin"],
		cwd => "/opt/",
		unless => "test -d /opt/go",
	}
}
