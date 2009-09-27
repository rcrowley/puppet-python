define pipinstall($version, $bin) {
	exec { "install-pip-0.4-$version":
		require => Exec["extract-pip-0.4"],
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
	exec { "extract-pip-0.4":
		require => File["/root/pip-0.4.tar.gz"],
		cwd => "/root",
		command => "tar xf /root/pip-0.4.tar.gz",
		creates => "/root/pip-0.4",
		#unless => "UNLESS WHAT???",
	}
	# If anything happened in order, each pipinstall would go here
	exec { "remove-pip-0.4":
		require => [
			Pipinstall["pip-0.4-3.1"],
			Pipinstall["pip-0.4-2.6.2"],
			Pipinstall["pip-0.4-2.5.4"]
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
		before => File["/opt/Python-$version/bin/python"],
		package => "Python",
		version => "$version",
		tarball => "puppet://$servername/python/Python-$version.tar.bz2",
		flags => "",
		bin => "python3",
	}
	pipinstall { "pip-0.4-$version":
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
		package => "Python",
		version => "$version",
		tarball => "puppet://$servername/python/Python-$version.tar.bz2",
		flags => "",
		bin => "python",
	}
	pipinstall { "pip-0.4-$version":
		version => "$version",
		bin => "python",
	}
}

class python::python_2_5_4 {
	$version = "2.5.4"
	sourceinstall { "Python-$version":
		package => "Python",
		version => "$version",
		tarball => "puppet://$servername/python/Python-$version.tar.bz2",
		flags => "",
		bin => "python",
	}
	pipinstall { "pip-0.4-$version":
		version => "$version",
		bin => "python",
	}
}
