extends Area3D

@export var long_fragment_scene: PackedScene  # La escena que quieres instanciar
@export var num_fragments: int = 10  # Número de fragmentos a generar
@export var fragment_gravity_scale: float = 1
@export var fragment_color = Color(255, 255, 255)

var area_global_position

func _ready() -> void:
	var fragment = get_node("../Building_1") as MeshInstance3D
	var material = fragment.mesh.surface_get_material(0)  # 0 es el índice de la superficie
	fragment_color = material.albedo_color
	# Obtener la posición global del Area3D
	area_global_position = global_transform.origin

# Función para generar posiciones aleatorias dentro de un Area3D cúbico
func generate_random_position_in_area() -> Vector3:
	# Obtener la forma de colisión (asumiendo que es BoxShape3D)
	var collision_shape = $CollisionShape3D.shape as BoxShape3D  # Obtener la forma de colisión
	var extents = collision_shape.extents  # Obtener las extensiones de la caja (tamaño)

	# Generar una posición aleatoria dentro del cubo definido por el Area3D
	var random_x = randf_range(-extents.x, extents.x)
	var random_y = randf_range(-extents.y, extents.y)
	var random_z = randf_range(-extents.z, extents.z)

	# La posición generada es relativa al Area3D
	return Vector3(random_x, random_y, random_z)

func _on_body_entered(body: Node3D) -> void:
	body.Destroy()

	# Generar y colocar los fragmentos
	for i in range(num_fragments):
		# Instanciar la escena del fragmento
		var fragment_instance = ObjectPool.get_long_fragment() #@long_fragment_scene.instantiate()

		# Configurar la gravedad y el color del fragmento
		fragment_instance.set_gravity_scale(fragment_gravity_scale)
		fragment_instance.set_color(fragment_color)

		# Generar una posición aleatoria dentro del área
		var random_position = generate_random_position_in_area()
		#print ("GLOBAL POSITION: ", global_position, " RANDOM_POSITION: ", random_position)
		fragment_instance.global_position = global_position + random_position
		#print ("FINAL POSITION: ", fragment_instance.global_position)

		# Aplicar una fuerza aleatoria al fragmento
		apply_random_force(fragment_instance)
		fragment_instance.show()

		# Agregar la instancia al árbol de nodos
		#add_child(fragment_instance)

func apply_random_force(fragment: RigidBody3D):
	var force_magnitude: float = randf_range(15, 45)

	var random_direction: Vector3
	while true:
		# Genera un Vector3 con componentes aleatorias entre -1 y 1
		random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()

		# Calcular el ángulo entre la dirección y el eje Y (Vector3.UP)
		var dot_product = random_direction.dot(Vector3.UP)
		var angle_in_degrees = acos(dot_product) * 180.0 / PI  # Convertir el ángulo de radianes a grados

		# Verificar que el ángulo sea mayor a 30 grados pero esté por encima del suelo
		if angle_in_degrees <= 60:  # Queremos fuerzas ascendentes, por encima de 30 grados respecto al suelo
			break  # Salir del bucle cuando se cumple la condición

	var random_torque = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))

	# Multiplica el vector normalizado por la magnitud de la fuerza deseada
	var force = random_direction * force_magnitude

	# Aplica la fuerza al fragmento
	fragment.apply_impulse(force, Vector3.ZERO)
	fragment.apply_torque(random_torque)
