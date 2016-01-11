# [class to install ruby and passenger]
# $version 				=> ruby version from https://www.brightbox.com/docs/ruby/ubuntu/ (1.9.3/2.0/2.1/2.2)
# $user					=> user for .gemrc file
# $passenger_version	=> passenger version
# $install_passenger 	=> for install passenger
# $repo 				=> repository for ruby

class ruby($version = '2.2',
	$passenger_version = '5.0.9',
	$user = undef,
	$install_passenger = 'false',
	$repo = 'ppa:brightbox/ruby-ng') {

	# ruby versions
	$ruby = ["ruby${version}", "ruby${version}-dev"]

	exec{ 'update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
	}

	# install dependencies
	class { 'ruby::dependencies::ubuntu::ubuntu': 
		require		=> Exec['update'],
	}

	# install repository
	class { 'ruby::repository':
		repo 		=> $repo,
		require		=> Class['ruby::dependencies::ubuntu::ubuntu'],
	}

	# install rubies
	package { $ruby:
		ensure		=> installed,
		require		=> Class['ruby::repository'],
	}

	# copy .gemrc
	if $user != undef{
		file {
			"/home/${user}/.gemrc":
			ensure  => present,
			source => 'puppet:///modules/ruby/.gemrc',
		}
	}

	# install passenger
	if $install_passenger == 'true' {
		class { 'ruby::passenger::passenger': 
			passenger_version	=> $passenger_version,
			ruby_version		=> $version,
			gem_version			=> $version,
			require		=> Package[$ruby],
		}
	}
		
}