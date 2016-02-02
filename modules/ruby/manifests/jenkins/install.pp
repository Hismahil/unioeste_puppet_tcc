# [git_repo]			git repository
# [github_proj_name]	name of project
# [git_branch]			branch of repository
# [job_dir_name]		name o job directory
# [sgdb_name]			switch a sgdb (mysql/postgres)
# [sgdb_install]		install sgdb?
# [username]			user for database
# [password] 			password for database
# [database]			name of database to create
# [gem_version]			version of gem

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
	$gem_version = undef) {

	# install jenkins and java
	class { 'jenkins':
		config_hash => {
			'JAVA_ARGS' => { 'value' => '-Xmx256m' }
		},
	}

	# config project to jenkins
	class { 'ruby::jenkins::config':
		git_repo				=> $git_repo, 
		github_proj_name		=> $github_proj_name, 
		git_branch				=> $git_branch, 
		build_interval 			=> $build_interval, 
		job_dir_name 			=> $job_dir_name,
		require					=> Class['jenkins'],
	}


	if $sgdb_install == 'true' {

		# install mysql
		if $sgdb_name == 'mysql' {
			class { 'ruby::dependencies::mysql::mysql':
				username	=> $username, 
				password	=> $password,
			}
		}
		else {
			# install postgres and create database
			if $database != undef {
				class {'ruby::dependencies::postgres::postgresql':
					data_base	=> $database,
					username	=> $username,
					password	=> $password,
				}
			}
			else {
				fail('Enter with a database')
			}
		}
	}

}