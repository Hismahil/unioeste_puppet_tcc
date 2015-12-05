node default {
	$server_name = 'app'
	$doc_root = '/var/www/app-rails-jenkins-test/public'
	class { 'ruby::passenger::vhost':
		server_name		=> $server_name,
		doc_root		=> $doc_root,
		rails_env		=> 'production',
	}
}