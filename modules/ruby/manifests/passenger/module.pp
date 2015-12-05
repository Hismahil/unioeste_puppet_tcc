class ruby::passenger::module($passenger_mod_path, $ruby_path, $passenger_path){
	
	file { '/etc/apache2/mods-available/passenger.load':
		ensure  => present,
		content => template('ruby/passenger-load.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
	}

	file { '/etc/apache2/mods-available/passenger.conf':
		ensure  => present,
		content => template('ruby/passenger-conf.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
	}

	exec {
		'a2enmod-passenger':
		command		=> 'a2enmod passenger',
		path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
		require		=> File['/etc/apache2/mods-available/passenger.load', '/etc/apache2/mods-available/passenger.conf'],
	}
	
}