node default {
	
	$ruby_version = '2.1' # para a versao do puppet da AIM feita

	# install ruby and passenger
	class { 'ruby': 
		version				=> $ruby_version
		user				=> 'ubuntu',
		install_passenger	=> 'true',
	}

	# install rails
	class { 'ruby::gem':
		gem		=> 'rails',
		version	=> '4.2.1',
		require	=> Class['ruby'],
	}

	# install mysql and create a user
	class { 'ruby::dependencies::mysql::mysql':
	    username  	=> 'vagrant',
	    password  	=> 'vagrant',
	    require		=> Class['ruby::gem'],
  	}

  	# install image magick for upload of images
  	package { 'imagemagick':
  		ensure	=> installed,
  	}
}