# [class to install ruby and passenger]
# $version 				=> ruby version from https://www.brightbox.com/docs/ruby/ubuntu/ (1.9.3/2.0/2.1/2.2)
# $user					=> user for .gemrc file
# $passenger_version	=> passenger version
# $install_passenger 	=> for install passenger
# $repo 				=> repository for ruby

class ruby($version = '2.2',			# default ruby version
	$passenger_version = '5.0.9',		# default passenger version
	$user = undef,						# for .gemrc
	$install_passenger = 'false',		# for install passenger
	$repo = 'ppa:brightbox/ruby-ng') {	# for other repository without RVM

	# ruby versions
	$ruby = ["ruby${version}", "ruby${version}-dev"]

	# apt update
	exec{ 'update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
	}

	# install dependencies
	class { 'ruby::dependencies::ubuntu::ubuntu': 
		require		=> Exec['update'], # install ruby and rails dependencies if apt update
	}

	# install repository
	class { 'ruby::repository':
		repo 		=> $repo,			# install repository
		require		=> Class['ruby::dependencies::ubuntu::ubuntu'], # require dependencies
	}

	# install rubies
	package { $ruby:
		ensure		=> installed,
		require		=> Class['ruby::repository'], 	#require repository
	}

	# copy .gemrc
	if $user != undef{
		file {
			"/home/${user}/.gemrc":		# current user
			ensure  => present,
			source => 'puppet:///modules/ruby/.gemrc',
		}
	}

	# install passenger
	if $install_passenger == 'true' {
		class { 'ruby::passenger::passenger': 
			passenger_version	=> $passenger_version,	# passenger version
			ruby_version		=> $version,			# ruby version
			gem_version			=> $version,			# gem version
			require		=> Package[$ruby],				# require ruby intalled
		}
	}
		
}