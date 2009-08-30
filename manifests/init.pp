class python {
	include python::python_3_1
	include python::python_2_6_2
	include python::python_2_5_4
}

class python::python_3_1 {
	sourceinstall { "Python-3.1":
		module => "python",
		package => "Python",
		version => "3.1",
		flags => "",
		bin => "python",
	}
}

class python::python_2_6_2 {
	sourceinstall { "Python-2.6.2":
		module => "python",
		package => "Python",
		version => "2.6.2",
		flags => "",
		bin => "python",
	}
}

class python::python_2_5_4 {
	sourceinstall { "Python-2.5.4":
		module => "python",
		package => "Python",
		version => "2.5.4",
		flags => "",
		bin => "python",
	}
}
