node default {
	service { 'sudo':
		ensure		=> 'running',
		enable		=> true,
	}
	
	exec { 'jenkins-sudo':
		command		=> 'adduser jenkins sudo',
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
		notify		=> Service['sudo'],
	}
}
	