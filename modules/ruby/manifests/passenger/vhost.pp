# [server_name]			name of application
# [doc_root]			path for application
# [disable_site]		for disable site
# [rails_env]			environment (production / development)

class ruby::passenger::vhost($server_name, $doc_root, $disable_site = undef, $rails_env){

	# create a site on apache	
	file { "/etc/apache2/sites-available/${server_name}.conf":
		ensure  => present,
		content => template('ruby/vhost.erb'),
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
	}

	# ability site
	exec {
		"a2ensite-${server_name}":
		command		=> "a2ensite ${server_name}",
		path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
		require		=> File["/etc/apache2/sites-available/${server_name}.conf"],
		notify		=> Service['apache2'], # try restart apache ...
	}
	
	# ensure apache running
	service { 'apache2':
		ensure  => 'running',
    	enable  => true,
	}

	# disable site 
	if $disable_site != undef {
		exec {
			"a2dissite-${disable_site}":
			command		=> "a2dissite ${disable_site}",
			path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
			require		=> Exec["a2ensite-${server_name}"],
			notify		=> Service['apache2'], # try restart apache ...
		}
	}
	
}