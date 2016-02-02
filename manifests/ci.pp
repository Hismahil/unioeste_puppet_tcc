node default {
	
	$ruby_version = '2.2'		# ruby version
	$rails_version = '4.2.1'	# rails version
	
	# install ruby without docs
	class { 'ruby':
		version		=> $ruby_version, 
    	user  		=> 'ubuntu',	# for copy .gemrc to current user
  	}

  	# install rails
  	class { 'ruby::gem':
    	gem   		=> 'rails',
    	version 	=> $rails_version,
    	require 	=> Class['ruby'], # install if ruby installed
  	}

  	# apt update
	exec { 'update-for-java':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin', # paths for apt
	}
	
	# install Java and Jenkins
	class { 'jenkins':
		config_hash => {
			'JAVA_ARGS' => { 'value' => '-Xmx256m' }
		},
		require		=> Exec['update-for-java'] # install if apt update
	}

	# plugins for Jenkins
	$plugins = [
		'ssh-credentials',
		'credentials',
		'scm-api',
		'git-client',
		'git',
		'github',
		'github-api',
		'mailer',
		'greenballs',
		'ws-cleanup',
		'rake',
		'postbuild-task'
	]

	# install plugins
	jenkins::plugin { $plugins: }

	# create Job of app Rails in Jenkins 
	class { 'ruby::jenkins::config':
		git_repo 		=> 'https://github.com/Hismahil/unioeste_app_tcc.git', 	# repository of application
		proj_name 		=> 'app', 												# name of Job on Jenkins
		git_branch 		=> '*/master', 											# branch on repository
		build_interval 	=> 'H * * * *', 										# build interval of Jenkins (1h)
		require			=> Class['jenkins'],									# install if Jenkins installed
	}

	# install mysql and create a user
	class { 'ruby::dependencies::mysql::mysql':
    	username  => 'vagrant',
    	password  => 'vagrant',
  	}

  	# make permission for Jenkins execute bundle install 
  	class { 'ruby::jenkins::permit':
  		require		=> Class['ruby::jenkins::config'],
  	}
}