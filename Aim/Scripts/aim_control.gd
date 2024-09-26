extends Control

func _ready():
	# Ocultar el cursor del sistema para que solo se vea la mira
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Asegurar que la mira esté centrada en la posición del mouse al comenzar
	_update_crosshair_position()

func _process(delta):
	# Actualizar la posición de la mira según la posición del mouse
	_update_crosshair_position()

func _update_crosshair_position():
	# Obtiene la posición actual del mouse
	var mouse_position = get_viewport().get_mouse_position()
	
	# Mueve la mira a la posición del mouse, centrando la mira
	position = mouse_position - size / 2
