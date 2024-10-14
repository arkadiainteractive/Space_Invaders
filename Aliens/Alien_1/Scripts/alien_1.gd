class_name Alien_1 extends Alien

func _on_a_lien_1_path_follow_3d_ready() -> void:
	path_follow = $".."
	print (self.name, " PATH FOLLOW: ", path_follow)
