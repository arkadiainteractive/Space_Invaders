extends Area3D

@export var long_fragment_scene: PackedScene  # La escena que quieres instanciar
@export var num_fragments: int = 10  # Número de fragmentos a generar
@export var fragment_gravity_scale: float = 1
@export var fragment_color = Color(255, 255, 255)

var area_global_position

func _ready() -> void:
	var fragment = get_node("../Building") as MeshInstance3D
	var material = fragment.mesh.surface_get_material(0)  # 0 es el índice de la superficie
	fragment_color = material.albedo_color
	# Obtener la posición global del Area3D
	area_global_position = global_transform.origin

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
		var random_position = ObjectPool.generate_random_position_in_area($CollisionShape3D)
		fragment_instance.global_position = global_position + random_position

		# Aplicar una fuerza aleatoria al fragmento
		ObjectPool.apply_random_force(fragment_instance, 5, 20)
		fragment_instance.show_fragment()
