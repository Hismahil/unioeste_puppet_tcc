#	[class to install any gem]
# $gem		- gem name
# $version	- version
class ruby::gem($gem, $version){
	
	package {
		$gem:
		ensure		=> $version,
		name		=> $gem,
		provider	=> 'gem',
	}
}