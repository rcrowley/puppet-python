define pipinstall($version, $bin) {
	exec { "pipinstall-exec-$version":
		require => Exec["pipinstall-extract"],
		cwd => "/root/pip-0.4",
		command => "/opt/Python-$version/bin/$bin setup.py install",
		creates => "/opt/Python-$version/bin/pip",
	}
}

class python {
	include python::python_3_1
	include python::python_2_6_2
	include python::python_2_5_4

	file { "/root/pip-0.4.tar.gz":
		require => [
			Sourceinstall["Python-3.1"],
			Sourceinstall["Python-2.6.2"],
			Sourceinstall["Python-2.5.4"]
		],
		source => "puppet://$servername/python/pip-0.4.tar.gz",
		ensure => present,
	}
	exec { "pipinstall-extract":
		require => File["/root/pip-0.4.tar.gz"],
		cwd => "/root",
		command => "tar xf /root/pip-0.4.tar.gz",
		creates => "/root/pip-0.4",
		#unless => "UNLESS WHAT???",
	}
	# If anything happened in order, each pipinstall would go here
	exec { "pipinstall-remove":
		require => [
			Pipinstall["pipinstall-3.1"],
			Pipinstall["pipinstall-2.6.2"],
			Pipinstall["pipinstall-2.5.4"]
		],
		command => "rm -rf /root/pip-0.4*",
	}

	file { "/usr/local/bin/pick-python":
		source => "puppet://$servername/python/pick-python",
		ensure => present,
	}

}

class python::python_3_1 {
	$version = "3.1"
	sourceinstall { "Python-$version":
		tarball => "http://python.org/ftp/python/$version/Python-$version.tar.bz2",
		prefix => "/opt/Python-$version",
		flags => "",
	}
	pipinstall { "pipinstall-$version":
		version => "$version",
		bin => "python3",
	}
	file { "/opt/Python-$version/bin/python":
		require => Sourceinstall["Python-$version"],
		ensure => "python3",
	}
}

class python::python_2_6_2 {
	$version = "2.6.2"
	sourceinstall { "Python-$version":
		tarball => "http://python.org/ftp/python/$version/Python-$version.tar.bz2",
		prefix => "/opt/Python-$version",
		flags => "",
	}
	pipinstall { "pipinstall-$version":
		version => "$version",
		bin => "python",
	}
}

class python::python_2_5_4 {
	$version = "2.5.4"
	sourceinstall { "Python-$version":
		tarball => "http://python.org/ftp/python/$version/Python-$version.tar.bz2",
		prefix => "/opt/Python-$version",
		flags => "",
	}
	pipinstall { "pipinstall-$version":
		version => "$version",
		bin => "python",
	}
}
