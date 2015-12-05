class chmod ($dir, $properties){
	
	exec {
		$dir:
			command		=> "chmod ${properties} ${dir}",
			path		=> '/bin:/sbin:/usr/bin:/usr/sbin',
	}
}