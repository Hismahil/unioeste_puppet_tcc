# key: 91758bfa3807a871730084978b9922b37e70de7596cb4debc942496d0e7b32639ad9ab5facbf984cb706a1de4c806bafaec1b91234f812d2595e2b9f26521c24
class ruby::rails::config($rails_app, $sgdb, $username, $password, $database, $secret_key_base, $disable_site = undef, $server_name){
	
	file { "${rails_app}/config/secrets.yml":
		ensure  => present,
		content => template('ruby/secrets.yml.erb'),
		require	=> Class['ruby::git::clone'],
	}

	file { "${rails_app}/config/database.yml":
		ensure  => present,
		content => template('ruby/database.yml.erb'),
		require	=> Class['ruby::git::clone'],
	}

	exec { 'deploy-without-dev-and-test':
		command		=> 'bundle install --deployment --without development test',
		path 		=> "/bin:/sbin:/usr/bin:/usr/sbin:${rails_app}/bin",
		require		=> File["${rails_app}/config/secrets.yml", "${rails_app}/config/database.yml"],
		timeout		=> 0,
	}

	exec { 'rake-db-env-production':
		command		=> 'rake db:create db:migrate RAILS_ENV=production',
		path 		=> "/bin:/sbin:/usr/bin:/usr/sbin:${rails_app}/bin",
		require		=> Exec['deploy-without-dev-and-test'],
		timeout		=> 0,
	}

	exec { 'rake-assets-precompile':
		command		=> 'rake assets:precompile RAILS_ENV=production',
		path 		=> "/bin:/sbin:/usr/bin:/usr/sbin:${rails_app}/bin",
		require		=> Exec['rake-db-env-production'],
		timeout		=> 0,
	}

	class { 'ruby::passenger::vhost':
		server_name		=> $server_name, 
		doc_root		=> $rails_app, 
		disable_site	=> $disable_site,
		rails_env 		=> 'production',
		require			=> Exec['rake-assets-precompile'],
	}
}