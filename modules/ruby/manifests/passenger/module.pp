# [passenger_mod_path]			path for passenger module
# [ruby_path]					path for ruby
# [passenger_path]				path for passenger gem

class ruby::passenger::module($passenger_mod_path, $ruby_path, $passenger_path){

	# create a passenger.load on apache	
	file { '/etc/apache2/mods-available/passenger.load':
		ensure  => present,
		content => template('ruby/passenger-load.erb'), # template of passenger.load
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
	}

	# create a passenger.conf on apache
	file { '/etc/apache2/mods-available/passenger.conf':
		ensure  => present,
		content => template('ruby/passenger-conf.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
	}

	# ability passenger module
	exec {
		'a2enmod-passenger':
		command		=> 'a2enmod passenger',
		path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
		require		=> File['/etc/apache2/mods-available/passenger.load', '/etc/apache2/mods-available/passenger.conf'],
	}
	
}