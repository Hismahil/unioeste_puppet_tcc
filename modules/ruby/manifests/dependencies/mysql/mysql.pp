class ruby::dependencies::mysql::mysql($username, $password){
	
	class { 'mysql::server':
	  root_password           => 'root',
	  remove_default_accounts => true,
	}

	mysql_user{ "${username}@%":
	  ensure        => present,
	  password_hash => mysql_password($password),
	  require       => Class['mysql::server'],
	}

	mysql_grant { "${username}@%/*.*":
	  ensure     => 'present',
	  options    => ['GRANT'],
	  privileges => ['ALL'],
	  table      => '*.*',
	  user       => "${username}@%",
	}
}