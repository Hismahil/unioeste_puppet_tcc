class ruby::jenkins::config (
	$git_repo 		= undef, 
	$proj_name 		= undef, 
	$git_branch 	= '*/master', 
	$build_interval = 'H * * * *'){
	
	if $git_repo != undef and $proj_name != undef {
		$job_dir_name = "/var/lib/jenkins/jobs/${proj_name}"

		file { '/var/lib/jenkins/jobs':
			ensure => 'directory',
			owner => 'jenkins',
			group => 'jenkins',
			require => Class['jenkins'],
		}

		file { $job_dir_name:
			ensure => 'directory',
			owner => 'jenkins',
			group => 'jenkins',
			require => File['/var/lib/jenkins/jobs'],
		}

		file { "${job_dir_name}/config.xml":
			mode => 0644,
			owner => 'jenkins',
			group => 'jenkins',
			content => template('ruby/config.xml.erb'),
			require => File[$job_dir_name],
		}

		file { "/var/lib/jenkins/credentials.xml":
			mode => 0644,
			owner => 'jenkins',
			group => 'jenkins',
			content => template('ruby/credentials.xml.erb'),
			require => File["${job_dir_name}/config.xml"],
		}
	}
	else {
		fail('Entre com todas as informacoes para configuracao da aplicacao: repositorio e nome do projeto')
	}
}