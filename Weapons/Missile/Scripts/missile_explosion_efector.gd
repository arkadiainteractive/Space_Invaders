extends Area3D

# La fuerza de la explosión
@export var explosion_force: float = 1000000.0
# El radio de la explosión
@export var explosion_radius: float = 50.0
# Duración de la explosión
@export var explosion_duration: float = 0.2

func _ready() -> void:
	$"../Fragments".connect("missile_explosion", _explosion_effector)

func trigger_explosion():
	# Obtén todos los cuerpos dentro del área
	var bodies = get_overlapping_bodies()

	if bodies.size() == 0:
		print("No se han detectado cuerpos dentro del área.")

	for body in bodies:
		if body is RigidBody3D:
			# Calcula la dirección de la explosión desde el centro del área hacia el cuerpo
			var direction = (body.global_transform.origin - global_transform.origin).normalized()
			# Calcula la distancia al cuerpo
			var distance = global_transform.origin.distance_to(body.global_transform.origin)
			# Aplica una fuerza inversamente proporcional a la distancia
			var force_magnitude = explosion_force * (1.0 - (distance / explosion_radius))
			# Aplica la fuerza al cuerpo
			body.apply_force(direction * 100.0, Vector3.ZERO)

# Método que se llama automáticamente cuando un cuerpo entra en el área
func _explosion_effector():
	trigger_explosion()
