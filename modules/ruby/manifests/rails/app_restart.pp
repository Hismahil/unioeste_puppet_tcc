define ruby::rails::app_restart($rails_app_path){
	
	file { "${rails_app_path}/tmp/restart.txt":
		ensure	=> present,
	}
}