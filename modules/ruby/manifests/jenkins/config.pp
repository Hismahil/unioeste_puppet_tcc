# [git_repo]			repository of application
# [proj_name]			name of Job on Jenkins
# [git_branch]			branch of application
# [build_interval]		build interval on Jenkins for application (1h)

class ruby::jenkins::config (
	$git_repo 		= undef, 
	$proj_name 		= undef, 
	$git_branch 	= '*/master', 
	$build_interval = 'H * * * *'){
	
	if $git_repo != undef and $proj_name != undef {
		$job_dir_name = "/var/lib/jenkins/jobs/${proj_name}"

		# create a dir jobs 
		file { '/var/lib/jenkins/jobs':
			ensure => 'directory',
			owner => 'jenkins',
			group => 'jenkins',
			require => Class['jenkins'],
		}

		# create a job app name dir
		file { $job_dir_name:
			ensure => 'directory',
			owner => 'jenkins',
			group => 'jenkins',
			require => File['/var/lib/jenkins/jobs'],
		}

		# create a config.xml for app
		file { "${job_dir_name}/config.xml":
			mode => 0644,
			owner => 'jenkins',
			group => 'jenkins',
			content => template('ruby/config.xml.erb'),
			require => File[$job_dir_name],
		}

	}
	else {
		fail('Enter with all information')
	}
}