class_name Alien_3 extends Alien

func _on_path_follow_3d_ready() -> void:
	path_follow = $".."
	print (self.name, " PATH FOLLOW: ", path_follow)
