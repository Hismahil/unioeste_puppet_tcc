#	[class to install repository brightbox]
class ruby::repository($repo){
	# install a repository for source.list
	exec{ 'ruby-ng':
		command		=> "apt-add-repository ${repo}",
		path		=> '/usr/bin:/bin',
	}

	# apt update
	exec{ 'repo-update':
		command		=> 'apt-get update',
		path		=> '/usr/bin:/bin',
		require		=> Exec['ruby-ng'],
	}
}