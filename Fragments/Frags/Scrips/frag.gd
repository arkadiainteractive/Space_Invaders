extends Node3D

var frag_scene
var frag_instance
var mesh_instance
var material
var color : Color

func _ready() -> void:
	#frag_scene = load("res://Fragments/LongFragment/Scenes/long_fragment.tscn")
	$"..".connect("exploded", _on_exploded_signal)

func Start() -> void:
	var frag_instance = ObjectPool.get_long_fragment() #@long_fragment_scene.instantiate()
	#frag_instance = frag_scene.instantiate()
	frag_instance.position = global_position
	ObjectPool.apply_random_force(frag_instance, 1, 50)

	mesh_instance = frag_instance.get_node("fragment")
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = $"../..".color
	#var material = $"../..".get_surface_override_material(0) as ShaderMaterial

	var new_material = material.duplicate()
	#new_material.albedo_color = $"..".color
	# Asignar el nuevo material al fragmento
	mesh_instance.set_surface_override_material(0, new_material)
	frag_instance.show()
	#get_tree().current_scene.add_child(frag_instance)

func _on_exploded_signal():
	Start()

#func apply_random_force(fragment: RigidBody3D):
	#var force_magnitude: float = randf_range(1, 50)
	## Genera un Vector3 con componentes aleatorias entre -1 y 1
	#var random_direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#var random_torque = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
	## Multiplica el vector normalizado por la magnitud de la fuerza deseada
	#var force = random_direction * force_magnitude
#
	## Aplica la fuerza al fragmento
	#fragment.apply_impulse(force, Vector3.ZERO)
	#fragment.apply_torque(random_torque)
