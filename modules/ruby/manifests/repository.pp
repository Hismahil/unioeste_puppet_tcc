#	[class to install repository brightbox]
class ruby::repository{
	exec{ 'ruby-ng':
		command		=> 'apt-add-repository ppa:brightbox/ruby-ng',
		path		=> '/usr/bin:/bin',
	}

	exec{ 'repo-update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
		require		=> Exec['ruby-ng'],
	}
}