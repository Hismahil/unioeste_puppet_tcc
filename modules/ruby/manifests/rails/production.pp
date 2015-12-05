class ruby::rails::production(
	$rails_app,
	$repository = undef,
	$toDir = undef, 
	$sgdb_name = 'mysql', 
	$sgdb_install = 'false', 
	$username, 
	$password, 
	$database, 
	$secret_key_base, 
	$disable_site = undef, 
	$server_name){
	
	if $sgdb_install == 'true' {
		if $sgdb_name == 'mysql'{
			class { 'ruby::dependencies::mysql::mysql':
				username 	=> $username,
				password	=> $password,
			}
		}
		else {
			if $database != undef {
				class {'ruby::dependencies::postgres::postgresql':
					data_base	=> $database,
					username	=> $username,
					password	=> $password,
				}
			} else {
				fail('Porfavor, especifique o database que será criado junto com a instalação do postgresql')
			}
		}
	}

	if $repository != undef and $toDir != undef {
		class { 'ruby::git::clone': 
			clone_repo	=> $repository, 
			toDir		=> $toDir,
		}
	}

	class { 'ruby::rails::config':
		rails_app 			=> $rails_app,
		sgdb				=> $sgdb_name,
		username			=> $username,
		password			=> $password,
		database 			=> $database,
		secret_key_base		=> $secret_key_base,
		disable_site		=> $disable_site,
		server_name			=> $server_name,
	}

}