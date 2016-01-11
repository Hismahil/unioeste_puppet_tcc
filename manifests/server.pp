node default {
	
	# install ruby and passenger
	class { 'ruby': 
		user				=> 'ubuntu',
		install_passenger	=> 'true',
	}

	# install rails
	class { 'ruby::gem':
		gem		=> 'rails',
		version	=> '4.2.1',
		require	=> Class['ruby'],
	}

	class { 'ruby::dependencies::mysql::mysql':
	    username  	=> 'vagrant',
	    password  	=> 'vagrant',
	    require		=> Class['ruby::gem'],
  	}

  	class { 'imagemagick':
  		ensure	=> installed,
  	}
}