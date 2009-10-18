class setuptoolsinstall::build {
	file { "/usr/local/sbin/setuptoolsinstall":
		source => "puppet://$servername/python/setuptoolsinstall",
		ensure => present,
	}
}

define setuptoolsinstall($egg, $prefix, $version) {
	include setuptoolsinstall::build
	exec { "/usr/local/sbin/setuptoolsinstall $egg $prefix >>/tmp/setuptoolsinstall.out 2>>/tmp/setuptoolsinstall.err":
		require => [
			Sourceinstall["Python-$version"],
			File["/usr/local/sbin/setuptoolsinstall"]
		],
		timeout => "-1",
	}
}

define pipinstall($version, $bin) {
	exec { "pipinstall-exec-$version":
		require => [
			Sourceinstall["Python-$version"],
			Setuptoolsinstall["setuptoolsinstall-$version"],
			Exec["pipinstall-extract"]
		],
		cwd => "/tmp/pip-0.5.1",
		command => "/opt/Python-$version/bin/$bin setup.py install",
		creates => "/opt/Python-$version/bin/pip",
	}
}

define pip($package, $version) {
	exec { "pip-exec-$package-$version":
		require => Pipinstall["pipinstall-$version"],
		command => "/opt/Python-$version/bin/pip install $package",
	}
}

class python {
	include python::python_3_1
	include python::python_2_6_2
	include python::python_2_5_4

	exec { "pipinstall-fetch":
		cwd => "/tmp",
		command => "wget http://pypi.python.org/packages/source/p/pip/pip-0.5.1.tar.gz",
	}
	exec { "pipinstall-extract":
		require => Exec["pipinstall-fetch"],
		cwd => "/tmp",
		command => "tar xf /tmp/pip-0.5.1.tar.gz",
		creates => "/tmp/pip-0.5.1",
		#unless => "UNLESS WHAT???",
	}
	# If anything happened in order, each pipinstall would go here
	exec { "pipinstall-remove":
		require => [
			Pipinstall["pipinstall-2.6.2"],
			Pipinstall["pipinstall-2.5.4"]
		],
		command => "rm -rf /tmp/pip-0.5.1*",
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
	setuptoolsinstall { "setuptoolsinstall-$version":
		egg => "http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c9-py2.6.egg",
		prefix => "/opt/Python-$version",
		version => "$version",
	}
	pipinstall { "pipinstall-$version":
		version => "$version",
		bin => "python",
	}
	pip { "virtualenv-$version":
		package => "virtualenv",
		version => "$version",
	}
}

class python::python_2_5_4 {
	$version = "2.5.4"
	sourceinstall { "Python-$version":
		tarball => "http://python.org/ftp/python/$version/Python-$version.tar.bz2",
		prefix => "/opt/Python-$version",
		flags => "",
	}
	setuptoolsinstall { "setuptoolsinstall-$version":
		egg => "http://pypi.python.org/packages/2.5/s/setuptools/setuptools-0.6c9-py2.5.egg",
		prefix => "/opt/Python-$version",
		version => "$version",
	}
	pipinstall { "pipinstall-$version":
		version => "$version",
		bin => "python",
	}
	pip { "virtualenv-$version":
		package => "virtualenv",
		version => "$version",
	}
}
