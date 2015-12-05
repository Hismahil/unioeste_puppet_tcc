class apache::dependencies{
	$list = ['libssl-dev', 'zlib1g-dev', 'apache2-mpm-prefork', 'apache2-prefork-dev', 'libapr1-dev']

	package { $list:
		ensure		=> installed,
	}
}