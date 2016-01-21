node default {
	$server_name = 'unioeste_app_tcc'
	$doc_root = '/var/www/unioeste_app_tcc/current/public'
	class { 'ruby::passenger::vhost':
		server_name		=> $server_name,
		doc_root		=> $doc_root,
		rails_env		=> 'production',
	}
}