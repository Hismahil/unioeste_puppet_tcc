node default {
	
	$ruby_version = '2.2'
	$rails_version = '4.2.1'
	
	# install ruby without docs
	class { 'ruby':
		version		=> $ruby_version, 
    	user  		=> 'ubuntu',
  	}

  	# install rails
  	class { 'ruby::gem':
    	gem   		=> 'rails',
    	version 	=> $rails_version,
    	require 	=> Class['ruby'],
  	}

  	# apt update
	exec { 'update-for-java':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
	}
	
	# install Java and Jenkins
	class { 'jenkins':
		config_hash => {
			'JAVA_ARGS' => { 'value' => '-Xmx256m' }
		},
		require		=> Exec['update-for-java']
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
		git_repo 		=> 'https://github.com/Hismahil/unioeste_app_tcc.git', 
		proj_name 		=> 'app', 
		git_branch 		=> '*/master', 
		build_interval 	=> 'H * * * *', 
		require			=> Class['jenkins'],
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