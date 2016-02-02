node default {
	
	$ruby_version = '2.1' # version with Syck, 2.2 no have

	# install ruby and passenger
	class { 'ruby': 
		version				=> $ruby_version,		# ruby version
		user				=> 'ubuntu',			# copy .gemrc for user
		install_passenger	=> 'true',				# install passenger and apache
	}

	# install rails
	class { 'ruby::gem':
		gem		=> 'rails',
		version	=> '4.2.1',
		require	=> Class['ruby'],		# install if ruby installed
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