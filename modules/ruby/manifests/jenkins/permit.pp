class ruby::jenkins::permit{
	exec { 'jenkins-sudo':
		command		=> 'adduser jenkins sudo',
		path		=> '/bin:/sbin:/usr/bin:/usr/sbin',
	}

	file { '/etc/sudoers':
		owner => 'root',
		group => 'root',
		ensure  => present,
		source => 'puppet:///modules/ruby/sudoers',
	}
}