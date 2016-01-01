node default {
	
	$ruby_version = '2.2'
	$rails_version = '4.2.1'
	
	class { 'ruby':
		version		=> $ruby_version, 
    	user  		=> 'vagrant',
  	}

  	# install rails
  	class { 'ruby::gem':
    	gem   		=> 'rails',
    	version 	=> $rails_version,
    	require 	=> Class['ruby'],
  	}

	exec { 'update-for-java':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
	}
	
	class { 'jenkins':
		config_hash => {
			'JAVA_ARGS' => { 'value' => '-Xmx256m' }
		},
		require		=> Exec['update-for-java']
	}

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

	jenkins::plugin { $plugins: }

	class { 'ruby::jenkins::config':
		git_repo 		=> 'https://github.com/Hismahil/app-rails-jenkins-test.git', 
		proj_name 		=> 'app', 
		git_branch 		=> '*/master', 
		build_interval 	=> 'H * * * *', 
		require			=> Class['jenkins'],
	}

	class { 'ruby::dependencies::mysql::mysql':
    	username  => 'vagrant',
    	password  => 'vagrant',
  	}

}