extends Control

var crosshair_sprite : Sprite2D
var target_enemy: Node = null  # Variable para almacenar el enemigo detectado
var lock_time: float = 1.0  # Tiempo necesario para fijar el objetivo
var lock_timer: float = 0.0  # Temporizador para el tiempo de fijación

var crosshair_lock_texture : Texture
var crosshair_texture : Texture
var locked : bool

signal enemy_locked(enemy, delta)  # Señal que se emitirá cuando un enemigo sea fijado
signal enemy_locked_loose()  # Señal de fijacion perdida.

enum CrosshairState {UNLOCKED, LOCKING, LOCKED}
var crosshair_state = CrosshairState.UNLOCKED

func _ready():
	crosshair_sprite = $CenterContainer/Crosshair
	crosshair_texture = load("res://Aim/Sprites/Crosshair.png")
	crosshair_lock_texture = load("res://Aim/Sprites/Locking_crosshair.png")
	#Player2.reset_aim.connect(_reset_aim)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_update_crosshair_position()

func _process(delta):
	_update_crosshair_position()

func _update_crosshair_position():
	var mouse_position = get_viewport().get_mouse_position()
	position = mouse_position - size / 2

func _on_update_ray_info(ray_result, delta):
	if ray_result and ray_result.collider and ray_result.collider.is_in_group("Enemy"):
		if target_enemy != ray_result.collider:
			_change_state(CrosshairState.LOCKING)
			target_enemy = ray_result.collider
			lock_timer = 0.0
			crosshair_sprite.modulate = Color(1, 1, 1)
		else:
			lock_timer += delta
			if lock_timer >= lock_time and crosshair_state == CrosshairState.LOCKING:
				# El estado solo cambiará a LOCKED cuando la animación de locking finalice
				emit_signal("enemy_locked", target_enemy, delta)
	else:
		if target_enemy:
			_change_state(CrosshairState.UNLOCKED)
			_reset_lock()

# Nueva función que controla las animaciones y visibilidad
func _update_visuals():
	match crosshair_state:
		CrosshairState.UNLOCKED:
			crosshair_sprite.texture = crosshair_texture
			$"../AnimationPlayer".stop()
			$CenterContainer/MissilLock.visible = false
			$CenterContainer/Crosshair.visible = true
			print ("UNLOCK")
		CrosshairState.LOCKING:
			crosshair_sprite.texture = crosshair_texture
			if not $"../AnimationPlayer".is_playing():
				$"../AnimationPlayer".play("locking")
		CrosshairState.LOCKED:
			crosshair_sprite.texture = crosshair_lock_texture
			$CenterContainer/MissilLock.visible = true
			$CenterContainer/Crosshair.visible = false

# Nueva función para manejar el cambio de estado de la mira
func _change_state(new_state):
	if new_state != crosshair_state:
		crosshair_state = new_state
		_update_visuals()

# Nueva función para manejar la finalización de la animación
func _on_animation_finished(anim_name):
	if anim_name == "locking" and crosshair_state == CrosshairState.LOCKING:
		_change_state(CrosshairState.LOCKED)

func _reset_aim():
	_change_state(CrosshairState.UNLOCKED)
	target_enemy = null
	lock_timer = 0.0
	#crosshair_sprite.modulate = Color(1, 1, 1)

func _reset_lock():
	emit_signal("enemy_locked_loose")
	_change_state(CrosshairState.UNLOCKED)
	target_enemy = null
	lock_timer = 0.0
	crosshair_sprite.modulate = Color(1, 1, 1)
