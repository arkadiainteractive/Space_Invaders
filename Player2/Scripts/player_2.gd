extends Node3D
class_name Player3person

@onready var camera: Camera3D = $Camera3D
@onready var cannon: CharacterBody3D = $Cannon
@onready var left_launcher: CharacterBody3D = $LeftLuncher
@onready var right_launcher: CharacterBody3D = $RightLuncher
@onready var aim_control_scene: PackedScene = load("res://Aim/Scenes/aim.tscn")
var max_rotation_angle = 0.523599  # 30 grados en radianes

var aim_control: Control
var fire_scene = load("res://Weapons/Fire/Scenes/fire.tscn")
var missile_scene = load("res://Weapons/Missile/Scenes/missile.tscn")
var fire_instance
var missile_instance
var missil_target = null
var number_of_missile = 0
var missile_mode = false
signal update_ray_info(ray_result, delta)
signal reset_aim
var left_launcher_initial_forward: Vector3
var right_launcher_initial_forward: Vector3
var fire_ready = true
var timer : Timer

func _ready():
	timer = $Timer
	self.reset_aim.connect(%Aim/%AimControl._reset_aim)
	self.update_ray_info.connect(%Aim/%AimControl._on_update_ray_info)
	%Aim/%AimControl.enemy_locked.connect(_on_enemy_locked)
	%Aim/%AimControl.enemy_locked_loose.connect(_on_enemy_locked_loose)

	# Guardar la dirección inicial de los launchers en su posición hacia adelante (-Z)
	left_launcher_initial_forward = -left_launcher.global_transform.basis.z.normalized()
	right_launcher_initial_forward = -right_launcher.global_transform.basis.z.normalized()

func _process(delta):
	# Proyectar el rayo desde la cámara y enviar la información a la mira
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var direction = camera.project_ray_normal(mouse_position) * 1000  # Longitud del rayo

	# Crear los parámetros del raycast utilizando PhysicsRayQueryParameters3D
	var ray_query = PhysicsRayQueryParameters3D.create(from, from + direction)
	ray_query.collide_with_areas = true  # Permitir colisionar con áreas
	ray_query.collide_with_bodies = true  # Permitir colisionar con cuerpos

	# Obtener el estado del espacio para realizar la intersección
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)

	if ray_result:
		var collider = ray_result.collider  # Obtener el objeto colisionado

	# Emitir la señal con la información del raycast
	if missile_mode:
		emit_signal("update_ray_info", ray_result, delta)

	if Input.is_action_just_pressed("fire"):
		if not fire_ready:
			return
		fire_ready = false
		timer.start()
		fire_instance = fire_scene.instantiate()
		fire_instance.position = $Cannon/FireSpot.global_position

		direction = cannon.global_transform.basis.z.normalized()
		get_tree().current_scene.add_child(fire_instance)
		fire_instance.velocity = direction * 50

	if Input.is_action_just_pressed("alter_fire"):
		if not missile_mode:
			missile_mode = true
		else:
			if !missil_target:
				return
			number_of_missile +=1
			missile_instance = missile_scene.instantiate()
			missile_instance.set_id(number_of_missile)
			var missile_scale = missile_instance.scale

			# Colocar el misil en la posición y rotación del lanzador derecho
			missile_instance.global_transform = right_launcher.global_transform
			missile_instance.position = $RightLuncher/RightMissileSpot.global_position
			# Obtener la dirección en la que apunta el lanzador y asignarla al misil
			direction = right_launcher.global_transform.basis.z.normalized()

			missile_instance.scale = -missile_scale

			missile_instance.set_target(missil_target)
			get_tree().current_scene.add_child(missile_instance)
			missile_mode = false
			emit_signal("reset_aim")

	mouse_position = get_viewport().get_mouse_position()

	from = camera.project_ray_origin(mouse_position)
	direction = camera.project_ray_normal(mouse_position)

	var target_position = from + -direction * 1000

	# Orientar el cañón hacia la posición objetivo (sin rotar 180 grados)
	cannon.look_at(target_position, Vector3.UP)

	# Ajustar la orientación de los launchers
	orient_launcher(left_launcher, target_position, left_launcher_initial_forward)
	orient_launcher(right_launcher, target_position, right_launcher_initial_forward)

func orient_launcher(launcher: CharacterBody3D, target_position: Vector3, initial_forward: Vector3):
	# Obtener la dirección del lanzador hacia el objetivo
	var direction_to_target = (target_position - launcher.global_transform.origin).normalized()

	# Calcular el ángulo entre la dirección inicial y la dirección hacia el objetivo
	var angle_to_target = initial_forward.angle_to(direction_to_target)

	# Verificar si el ángulo excede los 30 grados desde la dirección inicial
	if angle_to_target > max_rotation_angle:

		# Calcular la dirección limitada utilizando `slerp` para asegurarse de no exceder el límite
		var clamped_direction = initial_forward.slerp(direction_to_target, max_rotation_angle / angle_to_target).normalized()

		# Obtener la nueva posición del objetivo (limitada)
		var clamped_target_position = launcher.global_transform.origin + clamped_direction * 10  # Multiplica por la distancia deseada

		# Aplicar la rotación con el límite
		launcher.look_at(clamped_target_position, Vector3.UP)
	else:
		# Aplicar la rotación sin modificar si está dentro del límite
		launcher.look_at(target_position, Vector3.UP)

func _on_enemy_locked(target_enemy, delta):
	missil_target = target_enemy

func _on_enemy_locked_loose():
	missile_mode = false
	missil_target = null


func _on_timer_timeout() -> void:
	fire_ready = true
