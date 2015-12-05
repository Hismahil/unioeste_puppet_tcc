class ruby::rails::bundle($gems = {}){
	
	if is_hash($gems) and !empty($gems) {
		each($gems)|$gem, $version| {
			class { 'ruby::gem':
				gem 	=> $gem,
				version	=> $version,
			}
		}
	}
}