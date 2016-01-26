node default {
	$server_name = 'unioeste_app_tcc'
	$doc_root = '/var/www/unioeste_app_tcc/current/public'
	$old_site = '000-default.conf'
	
	# create a simple config file for site in Apache for app Rails
	class { 'ruby::passenger::vhost':
		server_name		=> $server_name,
		doc_root		=> $doc_root,
		rails_env		=> 'production',
		disable_site	=> $old_site,
	}
}