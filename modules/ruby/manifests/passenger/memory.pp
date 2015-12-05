class ruby::passenger::memory($bs = '1M', $count = '1024') {
	
	exec { 'swap-1g':
		command 	=> "dd if=/dev/zero of=/swap bs=${bs} count=${count}",
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
	}

	exec { 'mkswap':
		command		=> 'mkswap /swap',
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
		require		=> Exec['swap-1g'],
	}

	exec { 'swapon':
		command		=> 'swapon /swap',
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
		require		=> Exec['mkswap'],
	}
	
}