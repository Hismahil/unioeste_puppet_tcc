node default {
	# install passenger module for apache
	class { 'ruby::passenger::module':
		passenger_mod_path	=> '/var/lib/gems/2.0.0/gems/passenger-5.0.9/buildout/apache2/mod_passenger.so', # path complete
		ruby_path			=> '/usr/bin/ruby2.0', 
		passenger_path 		=> '/var/lib/gems/2.0.0/gems/passenger-5.0.9',
	}
}