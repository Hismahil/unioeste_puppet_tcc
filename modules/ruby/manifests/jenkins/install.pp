class ruby::jenkins::install(
	$git_repo, 
	$github_proj_name, 
	$git_branch = '*/master', 
	$build_interval = 'H * * * *', 
	$job_dir_name = '/var/lib/jenkins/jobs/app-rails-jenkins-test',
	$sgdb_name = 'mysql',
	$sgdb_install = 'false',
	$username,
	$password,
	$database = undef,
	$chmod_gem_path = 'false',
	$gem_version = undef) {

	class { 'jenkins':
		config_hash => {
			'JAVA_ARGS' => { 'value' => '-Xmx256m' }
		},
	}

	class { 'ruby::jenkins::config':
		git_repo				=> $git_repo, 
		github_proj_name		=> $github_proj_name, 
		git_branch				=> $git_branch, 
		build_interval 			=> $build_interval, 
		job_dir_name 			=> $job_dir_name,
		require					=> Class['jenkins'],
	}


	if $sgdb_install == 'true' {

		if $sgdb_name == 'mysql' {
			class { 'ruby::dependencies::mysql::mysql':
				username	=> $username, 
				password	=> $password,
			}
		}
		else {
			# postgres é instalado e já cria um database
			if $database != undef {
				class {'ruby::dependencies::postgres::postgresql':
					data_base	=> $database,
					username	=> $username,
					password	=> $password,
				}
			}
			else {
				fail('Porfavor, especifique o database que será criado junto com a instalação do postgresql')
			}
		}
	}

	if $chmod_gem_path == 'true' {
		class { 'chmod': 
			dir 			=> "/var/lib/gems/${gem_version}/gems", 
			properties		=> '777',
			require			=> Class['ruby'],
		}
	}
}