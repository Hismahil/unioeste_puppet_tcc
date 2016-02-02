# [bs]		number of bytes * M (1024 * 1024)
# [count]	number of blocks
class ruby::passenger::memory($bs = '1M', $count = '1024') {
	
	# create a file with 1gb
	exec { 'swap-1g':
		command 	=> "dd if=/dev/zero of=/swap bs=${bs} count=${count}",
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
	}

	# make a swap file
	exec { 'mkswap':
		command		=> 'mkswap /swap',
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
		require		=> Exec['swap-1g'],
	}

	# enable a swap file
	exec { 'swapon':
		command		=> 'swapon /swap',
		path		=> ['/usr/bin', '/bin', '/usr/local/bin', '/sbin'],
		require		=> Exec['mkswap'],
	}
	
}