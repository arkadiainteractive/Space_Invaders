extends Control

var crosshair_sprite : Sprite2D
var target_enemy: Node = null  # Variable para almacenar el enemigo detectado
var lock_time: float = 1.0  # Tiempo necesario para fijar el objetivo
var lock_timer: float = 0.0  # Temporizador para el tiempo de fijación

var crosshair_lock_texture : Texture
var crosshair_texture : Texture
var locked : bool

signal enemy_locked(enemy, delta)  # Señal que se emitirá cuando un enemigo sea fijado
signal enemy_locked_loose()  # Señal que se emitirá cuando un enemigo sea fijado

func _ready():
	#self.enemy_lockedg.connect(%Player2.on_enemy_locked)

	crosshair_sprite = $CenterContainer/Crosshair
	crosshair_texture = load ("res://Aim/Sprites/Crosshair.png")
	crosshair_lock_texture = load("res://Aim/Sprites/Locking_crosshair.png")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_update_crosshair_position()

func _process(delta):
	_update_crosshair_position()

func _update_crosshair_position():
	# Obtiene la posición actual del mouse y mueve la mira
	var mouse_position = get_viewport().get_mouse_position()
	position = mouse_position - size / 2

# Método que será llamado por la señal del player para recibir la información del raycast
func _on_update_ray_info(ray_result, delta):
	if crosshair_sprite == null:
		crosshair_sprite = $CenterContainer/Crosshair
	if ray_result and ray_result.collider and ray_result.collider.is_in_group("Enemy"):
		if target_enemy != ray_result.collider:
			locked = false
			# Nuevo objetivo detectado, reinicia el temporizador
			target_enemy = ray_result.collider
			lock_timer = 0.0
			crosshair_sprite.modulate = Color(1, 1, 1)  # Asegurarse de que el color de la mira sea blanco mientras fija el objetivo
		else:
			if locked:
				return
			# Incrementa el temporizador si sigue apuntando al mismo objetivo:
			lock_timer += delta #get_process_delta_time()
			if lock_timer >= lock_time:
				locked = true
				$"../AnimationPlayer".play("locking")
				# Objetivo fijado, cambia la apariencia de la mira
				crosshair_sprite.texture = crosshair_lock_texture # Cambia la textura de la mira cuando el objetivo está fijado
				#crosshair_sprite.modulate = Color(1, 1, 1)  # Cambia a rojo
				emit_signal("enemy_locked", target_enemy, delta)  # Emite la señal con el objetivo fijado
	else:
		if target_enemy:
			if crosshair_sprite:
				_reset_lock()

func _reset_lock():
	emit_signal("enemy_locked_loose")  # Emite la señal con el objetivo fijado
	if crosshair_sprite == null:
		crosshair_sprite = $CenterContainer/Crosshair
	# Reinicia el estado de fijación
	target_enemy = null
	lock_timer = 0.0
	crosshair_sprite.texture = crosshair_texture  # Cambia a la textura original
	crosshair_sprite.modulate = Color(1, 1, 1)  # Cambia a blanco
