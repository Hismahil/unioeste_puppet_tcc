class ruby::jenkins::plugins($plugins){
	jenkins::plugin { $plugins: }
}