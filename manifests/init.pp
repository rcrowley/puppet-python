class python {
	include python::python_3_1
	include python::python_2_6_2
	include python::python_2_5_4
}

class python::python_3_1 {
	$version = "3.1"
	sourceinstall { "Python-$version":
		package => "Python",
		version => "$version",
		tarball => "puppet://$servername/python/Python-$version.tar.bz2",
		flags => "",
		bin => "python",
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
}
