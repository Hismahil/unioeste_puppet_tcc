node default {
	
	$ruby_version = '2.0'
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
	
	if versioncmp($ruby_version, '1.9.3') == 0 {
		$chmod_gem_version = '1.9.3'
	}
	else {
		$chmod_gem_version = "${ruby_version}.0"
	}

	if $chmod_gem_version != undef {
		class { 'chmod': 
			dir 			=> "/var/lib/gems/${chmod_gem_version}/gems", 
			properties		=> '777',
			require			=> Class['ruby'],
		}
	}
	else {
		fail('Não foi possivel mudar as permissões na pasta gems')	
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