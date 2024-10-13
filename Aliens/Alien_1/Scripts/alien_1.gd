class_name Alien_1 extends Alien

func _alien_process(delta):
	# Incrementamos el progreso de la nave en la ruta
	path_follow.progress_ratio += speed * delta
	print("PATH: ", path_follow.progress_ratio)

	# Reiniciar el progreso cuando llega al final para hacer un bucle
	if path_follow.progress_ratio >= 1.0:
		path_follow.progress_ratio = 0.0  # Repetir el recorrido
