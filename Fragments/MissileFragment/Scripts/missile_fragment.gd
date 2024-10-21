class_name Missile_fragment extends Fragment

func _physics_process(delta: float) -> void:
	if angular_velocity != Vector3.ZERO:
		print ("ACA PASO ALGO RARO...: ", self.name)
