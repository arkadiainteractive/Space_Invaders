class_name Missile extends CharacterBody3D

@export var color = Color(255, 255, 255)
var num_fragments: int = 60
var mesh_instance
var material

@onready var explosion_scene = preload("res://Weapons/Missile/Scenes/explosion.tscn")
var explosion_instance

const SPEED = 5.0
const VELOCITY = 10
var target : Area3D

var speed: float = 10.0  # Velocidad del misil
var turn_speed: float = 3.0  # Velocidad de giro del misil
var id = null

func _ready() -> void:
	explosion_instance = explosion_scene.instantiate() # Instancia la escena

func set_color (new_color : Color):
	color = new_color

func get_color ():
	return color

func set_id(id_number: int):
	id = id_number

func set_target(target_area: Area3D):
	target = target_area

func _physics_process(delta):
	if target and is_instance_valid(target):
		# Obtener la posición del objetivo
		var target_position = target.global_transform.origin

		# Orientar el misil hacia el objetivo usando look_at
		look_at(target_position, Vector3.UP)

		# Calcular la dirección hacia el objetivo
		var direction = (target_position - global_transform.origin).normalized()

		# Mover el misil hacia el objetivo
		global_translate(direction * speed * delta)
		move_and_slide()
	else:
		Destroy()

func Destroy():
	explosion_instance.global_transform.origin = global_position # Posiciona la explosión
	get_tree().root.add_child(explosion_instance) # Añádela como hijo del árbol de nodos

	for i in range(num_fragments):
		var frag_instance = ObjectPool.get_missile_fragment()
		print ("FUERZA: ", frag_instance.linear_velocity)
		var random_position = ObjectPool.generate_random_position_in_area ($Area3D/CollisionShape3D)
		frag_instance.global_position = global_position + random_position
		ObjectPool.apply_random_force(frag_instance, 10, 55)
		frag_instance.set_color(color)
		frag_instance.show_fragment()
	queue_free()

func _on_missile_destroyed_signal():
	queue_free()
