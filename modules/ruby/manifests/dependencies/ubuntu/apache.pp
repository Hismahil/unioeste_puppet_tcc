class ruby::dependencies::ubuntu::apache{
	exec {
    	'apt-libssl-dev':
    		command		=> "echo 'deb http://security.ubuntu.com/ubuntu precise-security main' >> /etc/apt/sources.list",
			path		=> '/usr/bin:/bin',
    }

    exec {
    	'apt-libaprutil1-dev':
    		command		=> "echo 'deb http://cz.archive.ubuntu.com/ubuntu trusty main' >> /etc/apt/sources.list",
    		path		=> '/usr/bin:/bin',
    }
    
    exec {
    	'apt-apache2-dev':
    		command		=> "echo 'deb http://security.ubuntu.com/ubuntu trusty-security main' >> /etc/apt/sources.list",
    		path		=> '/usr/bin:/bin',
    }

    exec{ 'apt-apache-update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
		require		=> Exec['apt-libssl-dev', 'apt-libaprutil1-dev', 'apt-apache2-dev'],
	}

	$dep = ['apache2-mpm-prefork', 'libruby', 'libcurl4-gnutls-dev', 'libssl-dev', 'apache2-dev']

    package {
    	$dep:
    		ensure	=> installed,
    		require	=> Exec['apt-apache-update'],
    }

}