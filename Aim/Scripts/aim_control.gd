#extends Control
#
#func _ready():
	## Ocultar el cursor del sistema para que solo se vea la mira
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#
	## Asegurar que la mira esté centrada en la posición del mouse al comenzar
	#_update_crosshair_position()
#
#func _process(delta):
	## Actualizar la posición de la mira según la posición del mouse
	#_update_crosshair_position()
#
#func _update_crosshair_position():
	## Obtiene la posición actual del mouse
	#var mouse_position = get_viewport().get_mouse_position()
#
	## Mueve la mira a la posición del mouse, centrando la mira
	#position = mouse_position - size / 2
extends Control

@onready var crosshair_sprite: Sprite2D = $CenterContainer/Sprite2D  # Referencia al sprite de la mira
var target_enemy: Node = null  # Variable para almacenar el enemigo detectado
var lock_time: float = 2.0  # Tiempo necesario para fijar el objetivo
var lock_timer: float = 0.0  # Temporizador para el tiempo de fijación

signal enemy_locked(enemy)  # Señal que se emitirá cuando un enemigo sea fijado

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_update_crosshair_position()

func _process(delta):
	_update_crosshair_position()

func _update_crosshair_position():
	# Obtiene la posición actual del mouse y mueve la mira
	var mouse_position = get_viewport().get_mouse_position()
	position = mouse_position - size / 2

# Este método será llamado por la señal del player para recibir la información del raycast
func on_update_ray_info(ray_result):
	if ray_result and ray_result.collider and ray_result.collider.is_in_group("Enemy"):
		if target_enemy != ray_result.collider:
			# Nuevo objetivo detectado, reinicia el temporizador
			target_enemy = ray_result.collider
			lock_timer = 0.0
			crosshair_sprite.modulate = Color(1, 1, 1)  # Asegurarse de que el color de la mira sea blanco mientras fija el objetivo
		else:
			# Incrementa el temporizador si sigue apuntando al mismo objetivo
			lock_timer += get_process_delta_time()
			if lock_timer >= lock_time:
				# Objetivo fijado, cambia la apariencia de la mira
				crosshair_sprite.texture = preload("res://Aim/Sprites/locked_aim.png")  # Cambia la textura de la mira cuando el objetivo está fijado
				crosshair_sprite.modulate = Color(1, 0, 0)  # Cambia a rojo
				emit_signal("enemy_locked", target_enemy)  # Emite la señal con el objetivo fijado
	else:
		_reset_lock()

func _reset_lock():
	# Reinicia el estado de fijación
	target_enemy = null
	lock_timer = 0.0
	crosshair_sprite.texture = preload("res://Aim/Sprites/Crosshair.png")  # Cambia a la textura original
	crosshair_sprite.modulate = Color(1, 1, 1)  # Cambia a blanco
