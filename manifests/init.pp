define python_install($version) {

	file { "/opt/Python-$version.tar.bz2":
		before => Exec["extract-Python-$version"],
		source => "puppet://$servername/python/Python-$version.tar.bz2",
		ensure => present,
	}
	exec { "extract-Python-$version":
		require => File["/opt/Python-$version.tar.bz2"],
		before => Exec["configure-Python-$version"],
		cwd => "/root",
		command => "tar xjf /opt/Python-$version.tar.bz2",
		creates => "/root/Python-$version",
		unless => "test -d /opt/Python-$version",
	}

	exec { "configure-Python-$version":
		require => Exec["extract-Python-$version"],
		before => Exec["make-Python-$version"],
		cwd => "/root/Python-$version",
		command => "./configure --prefix=/opt/Python-$version $flags",
		timeout => "-1",
		creates => "/root/Python-$version/Makefile",
		onlyif => "test -d /root/Python-$version",
	}
	exec { "make-Python-$version":
		require => Exec["configure-Python-$version"],
		before => Exec["install-Python-$version"],
		cwd => "/root/Python-$version",
		command => "make",
		timeout => "-1",
		creates => "/root/Python-$version/Python",
		onlyif => "test -d /root/Python-$version",
	}
	exec { "install-Python-$version":
		require => Exec["make-Python-$version"],
		before => Exec["remove-Python-$version"],
		cwd => "/root/Python-$version",
		command => "make install",
		creates => "/opt/Python-$version",
		onlyif => "test -d /root/Python-$version",
	}

	exec { "remove-Python-$version":
		cwd => "/root",
		command => "rm -rf Python-$version",
		onlyif => "test -d /root/Python-$version",
	}

}

class python {
	include python::python_3_1
	include python::python_2_6_2
	include python::python_2_5_4
}

class python::python_3_1 {
	python_install { "Python-3.1": version => "3.1" }
}

class python::python_2_6_2 {
	python_install { "Python-2.6.2": version => "2.6.2" }
}

class python::python_2_5_4 {
	python_install { "Python-2.5.4": version => "2.5.4" }
}
