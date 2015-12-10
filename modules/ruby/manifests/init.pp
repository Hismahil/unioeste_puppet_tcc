# [class to install ruby and passenger]
# $version 				=> ruby version from https://www.brightbox.com/docs/ruby/ubuntu/ (1.9.3/2.0/2.1/2.2)
# $user					=> user for .gemrc file
# $passenger_version	=> passenger version
# $install_passenger 	=> for install passenger

class ruby($version = '2.2',
	$passenger_version = '5.0.9',
	$user = undef,
	$install_passenger = 'false') {

	$ruby = ["ruby${version}", "ruby${version}-dev"]

	exec{ 'update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
	}

	class { 'ruby::dependencies::ubuntu::ubuntu': 
		require		=> Exec['update'],
	}

	class { 'ruby::repository': 
		require		=> Class['ruby::dependencies::ubuntu::ubuntu'],
	}

	package { $ruby:
		ensure		=> installed,
		require		=> Class['ruby::repository'],
	}

	if $user != undef{
		file {
			"/home/${user}/.gemrc":
			ensure  => present,
			source => 'puppet:///modules/ruby/.gemrc',
		}
	}

	if $install_passenger == 'true' {
		class { 'ruby::passenger::passenger': 
			passenger_version	=> $passenger_version,
			ruby_version		=> $version,
			gem_version			=> $version,
			require		=> Package[$ruby],
		}
	}
		
}