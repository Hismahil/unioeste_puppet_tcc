# [class made for copy repositories]
# $user 		- set a user for git
# $email 		- set a email for git
# $clone_repo	- URL for repositorie
# $toDir		- path for a empty folder (it create if not exist)
class ruby::git::clone($user = undef, $email = undef, $clone_repo, $toDir){

	if $user != undef {
		exec {'set-git-user':
			command		=> "git config --global user.name = ${user}",
			path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
		}
	}

	if $email != undef {
		exec {'set-git-email':
			command		=> "git config --global user.email = ${email}",
			path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
		}
	}
	
	exec {"git-clone-${clone_repo}":
		command		=> "git clone ${clone_repo} ${toDir}",
		path 		=> '/bin:/sbin:/usr/bin:/usr/sbin',
	}
}