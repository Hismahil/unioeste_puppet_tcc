class ruby::dependencies::postgres::postgresql($data_base, $username, $password){
	
	package { 'libpq-dev':
		ensure		=> installed,
	}

	class { 'postgresql::server':
	  ip_mask_deny_postgres_user 	=> '0.0.0.0/32',
	  ip_mask_allow_all_users    	=> '0.0.0.0/0',
	  listen_addresses           	=> '*',
	  postgres_password          	=> 'postgres',
	  require						=> Package['libpq-dev'],
	}

	postgresql::server::db { $data_base:
	  user     => $username,
	  password => postgresql_password($password, $password),
	}

}