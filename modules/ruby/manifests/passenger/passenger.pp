class ruby::passenger::passenger(
	$passenger_version = '5.0.9',
	$ruby_version,
	$gem_version,
	$http_server = 'apache') {

	# if passenger > 4.0 use 'buildout' for path to mod_passenger.so, else 'ext'
	if versioncmp ($passenger_version, '4.0.0') > 0 {
    	$dir     = 'buildout'
  	} else {
    	$dir     = 'ext'
  	}

	$ruby_path = "/usr/bin/ruby${ruby_version}"
	#if ruby version == 1.9.3
	if versioncmp($ruby_version, '1.9.3') == 0 {
		$gems_path = "/var/lib/gems/${gem_version}/gems"
		$gem_bin_path = "/var/lib/gems/${gem_version}/bin"
		$passenger_path = "/var/lib/gems/${gem_version}/gems/passenger-${passenger_version}"
		$passenger_mod_path = "/var/lib/gems/${gem_version}/gems/passenger-${passenger_version}/${dir}/apache2/mod_passenger.so"
	}
	else { #else append .0
		$gems_path = "/var/lib/gems/${gem_version}.0/gems"
		$gem_bin_path = "/var/lib/gems/${gem_version}.0/bin"
		$passenger_path = "/var/lib/gems/${gem_version}.0/gems/passenger-${passenger_version}"
		$passenger_mod_path = "/var/lib/gems/${gem_version}.0/gems/passenger-${passenger_version}/${dir}/apache2/mod_passenger.so"
	}

	# gem install passenger
	package { 'passenger':
	    ensure   => $passenger_version,
	    name     => 'passenger',
	    provider => 'gem',
  	}

  	# set swap memory for virtual machine
  	class { 'ruby::passenger::memory': 
  		require		=> Package['passenger'],
  	}

  	# exec script
	if $http_server == 'apache' {
		
		class { 'apache': } # install apache
		class { 'ruby::dependencies::ubuntu::apache': #install passenger dependencies
			require		=> Class['apache'],
		}

		exec { 'passenger-apache-compile':
			path      	=> [ "${passenger_path}/bin/passenger", '/usr/bin', '/bin', '/usr/local/bin' ],
	    	command   	=> 'passenger-install-apache2-module -a',
	    	creates   	=> $passenger_mod_path,
	    	timeout   	=> 0,
	    	require		=> Class['ruby::passenger::memory', 'ruby::dependencies::ubuntu::apache'],
		}

		# set module for apache.conf
		class { 'ruby::passenger::module':
			passenger_mod_path 		=> $passenger_mod_path, 
			ruby_path 				=> $ruby_path, 
			passenger_path 			=> $passenger_path,
			require					=> Exec['passenger-apache-compile'],
		}
	}
	else {
		# nao implementado
	}
		
}