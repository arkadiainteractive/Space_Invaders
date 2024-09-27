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

# Variables para almacenar la dirección inicial de los launchers
var left_launcher_initial_forward: Vector3
var right_launcher_initial_forward: Vector3

func _ready():
	print("Inicializando")

	if aim_control_scene:
		var aim_control_instance = aim_control_scene.instantiate()
		print("AIM_CONTROL_INSTANCE: ", aim_control_instance)

		get_tree().root.add_child(aim_control_instance)
		aim_control = aim_control_instance.get_node("AimControl")

		print("Mira inicializada correctamente: ", aim_control)
	else:
		print("Error: La escena de la mira no está asignada.")
	
	# Guardar la dirección inicial de los launchers en su posición hacia adelante (-Z)
	left_launcher_initial_forward = -left_launcher.global_transform.basis.z.normalized()
	right_launcher_initial_forward = -right_launcher.global_transform.basis.z.normalized()

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		print("FIRE!")
		fire_instance = fire_scene.instantiate()
		fire_instance.position = $Cannon/FireSpot.global_position
		print("INSTANCIA DE FIRE: ", fire_instance)

		var direction = cannon.global_transform.basis.z.normalized()
		get_tree().current_scene.add_child(fire_instance)
		fire_instance.velocity = direction * 50

	if Input.is_action_just_pressed("alter_fire"):
		print("MISSILE!")
		missile_instance = missile_scene.instantiate()
		var missile_scale = missile_instance.scale

		# Colocar el misil en la posición y rotación del lanzador derecho
		missile_instance.global_transform = right_launcher.global_transform
		missile_instance.position = $RightLuncher/RightMissileSpot.global_position

		print("INSTANCIA DE MISIL: ", missile_instance)

		# Obtener la dirección en la que apunta el lanzador y asignarla al misil
		var direction = right_launcher.global_transform.basis.z.normalized()

		missile_instance.scale = -missile_scale

		get_tree().current_scene.add_child(missile_instance)
		missile_instance.velocity = direction * 50

	if aim_control != null:
		var mouse_position = get_viewport().get_mouse_position()

		var from = camera.project_ray_origin(mouse_position)
		var direction = camera.project_ray_normal(mouse_position)

		var target_position = from + -direction * 1000

		# Orientar el cañón hacia la posición objetivo (sin rotar 180 grados)
		cannon.look_at(target_position, Vector3.UP)

		# Ajustar la orientación de los launchers
		orient_launcher(left_launcher, target_position, left_launcher_initial_forward)
		orient_launcher(right_launcher, target_position, right_launcher_initial_forward)
	else:
		print("Error: aim_control es null.")

func orient_launcher(launcher: CharacterBody3D, target_position: Vector3, initial_forward: Vector3):
	# Obtener la dirección del lanzador hacia el objetivo
	var direction_to_target = (target_position - launcher.global_transform.origin).normalized()

	# Calcular el ángulo entre la dirección inicial y la dirección hacia el objetivo
	var angle_to_target = initial_forward.angle_to(direction_to_target)

	# Verificar si el ángulo excede los 30 grados desde la dirección inicial
	if angle_to_target > max_rotation_angle:
		print("Limitando a 30 grados desde la posición inicial")
		# Calcular la dirección limitada utilizando `slerp` para asegurarse de no exceder el límite
		var clamped_direction = initial_forward.slerp(direction_to_target, max_rotation_angle / angle_to_target).normalized()

		# Obtener la nueva posición objetivo limitada
		var clamped_target_position = launcher.global_transform.origin + clamped_direction * 10  # Multiplica por la distancia deseada

		# Aplicar la rotación con el límite
		launcher.look_at(clamped_target_position, Vector3.UP)
	else:
		# Aplicar la rotación sin modificar si está dentro del límite
		launcher.look_at(target_position, Vector3.UP)
