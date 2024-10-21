class_name Object_Pool extends Node

@onready var long_fragment_scene = preload("res://Fragments/LongFragment/Scenes/long_fragment.tscn")
@onready var missile_fragmen_scene = preload("res://Fragments/MissileFragment/Scenes/missile_fragment.tscn")
# Variable para almacenar el pool
var long_fragment_pool = []
var long_fragment_pool_size = 500  # Tamaño máximo del pool

var missile_fragment_pool = []
var missile_fragment_pool_size = 60  # Tamaño máximo del pool

# Singleton Initialization
func _ready():
	# Pre-instanciar los long_fragment_pool.
	for i in range(long_fragment_pool_size):
		var long_fragment = long_fragment_scene.instantiate()
		#long_fragment.sleeping = true
		#long_fragment.linear_velocity = Vector3.ZERO
		#long_fragment.angular_velocity = Vector3.ZERO
		long_fragment.hide_fragment()  # Ocultarlos hasta que sean usados
		add_child(long_fragment)  # Añadirlos como hijos del pool
		long_fragment_pool.append(long_fragment)

	for i in range(missile_fragment_pool_size):
		var missile_fragment = missile_fragmen_scene.instantiate()
		#missile_fragment.freeze = true
		#missile_fragment.sleeping = true
		#missile_fragment.collision_layer = 0
		#missile_fragment.collision_mask = true
		#missile_fragment.linear_velocity = Vector3.ZERO
		#missile_fragment.angular_velocity = Vector3.ZERO
		missile_fragment.hide_fragment()  # Ocultarlos hasta que sean usados
		add_child(missile_fragment)  # Añadirlos como hijos del pool
		missile_fragment_pool.append(missile_fragment)

# Método para obtener un fragmento disponible
func get_long_fragment():
	for fragment in long_fragment_pool:
		if fragment.is_hidden():
			fragment.freeze = false
			fragment.sleeping = false
			return fragment
	print("No fragments available in the pool.")
	return null

func get_missile_fragment():
	for fragment in missile_fragment_pool:
		if fragment.is_hidden():
			fragment.freeze = false
			fragment.sleeping = false
			return fragment
	print("No fragments available in the pool.")
	return null

func generate_random_position_in_area(shape: CollisionShape3D) -> Vector3:
	var collision_shape = shape.shape as BoxShape3D
	# Obtener la forma de colisión (asumiendo que es BoxShape3D)
	var extents = collision_shape.extents  # Obtener las extensiones de la caja (tamaño)

	# Generar una posición aleatoria dentro del cubo definido por el Area3D
	var random_x = randf_range(-extents.x, extents.x)
	var random_y = randf_range(-extents.y, extents.y)
	var random_z = randf_range(-extents.z, extents.z)

	# La posición generada es relativa al Area3D
	return Vector3(random_x, random_y, random_z)

func apply_random_force(fragment: RigidBody3D, min_force: float, max_force: float):
	var force_magnitude = randf_range(min_force, max_force)
	# Genera un Vector3 con componentes aleatorias entre -1 y 1
	var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var random_torque = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
	# Multiplica el vector normalizado por la magnitud de la fuerza deseada
	var force = random_direction * force_magnitude

	# Aplica la fuerza al fragmento
	fragment.apply_impulse(force, Vector3.ZERO)
	fragment.apply_torque(random_torque)
