# Copy files for permission to bundle install

class ruby::jenkins::permit{

	# add jenkins for sudo group
	exec { 'jenkins-sudo':
		command		=> 'adduser jenkins sudo',
		path		=> '/bin:/sbin:/usr/bin:/usr/sbin',
	}

	# no password for sudo
	file { '/etc/sudoers':
		owner => 'root',
		group => 'root',
		ensure  => present,
		source => 'puppet:///modules/ruby/sudoers',
	}
}