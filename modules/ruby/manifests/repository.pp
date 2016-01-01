#	[class to install repository brightbox]
class ruby::repository($repo){
	exec{ 'ruby-ng':
		command		=> "apt-add-repository ${repo}",
		path		=> '/usr/bin:/bin',
	}

	exec{ 'repo-update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
		require		=> Exec['ruby-ng'],
	}
}