extends Area3D

# La fuerza de la explosión
@export var explosion_force: float = 1000.0
# El radio de la explosión
@export var explosion_radius: float = 5.0
# Duración de la explosión
@export var explosion_duration: float = 0.2

func _ready() -> void:
	$"../Fragments".connect("missile_explosion", _explosion_effector)

# Método para iniciar la explosión
#func trigger_explosion():
	#print ("EXPLOTA ESTA PUTA MIERDA")
	#set_monitoring(true)
	#set_monitorable(true)
	## Obtén todos los cuerpos dentro del área
	#var bodies = get_overlapping_bodies()
#
	#for body in bodies:
		#if body is RigidBody3D:
			## Calcula la dirección de la explosión desde el centro del área hacia el cuerpo
			#var direction = (body.global_transform.origin - global_transform.origin).normalized()
			## Calcula la distancia al cuerpo
			#var distance = global_transform.origin.distance_to(body.global_transform.origin)
			## Aplica una fuerza inversamente proporcional a la distancia
			#var force_magnitude = explosion_force * (1.0 - (distance / explosion_radius))
			## Aplica la fuerza al cuerpo
			#body.apply_impulse(Vector3(), direction * force_magnitude)
#
	## Opcional: Desactivar el Area3D después de la explosión
	##yield(get_tree().create_timer(explosion_duration), "timeout")
	#queue_free() # Elimina el área después de la explosión

func trigger_explosion():
	print("EXPLOTA ESTA PUTA MIERDA")
	# Verificar si el Area3D está monitoreando correctamente
	#set_monitoring(true)

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
			body.apply_impulse(Vector3(), direction * force_magnitude)

	queue_free()  # Elimina el área después de la explosión


# Método que se llama automáticamente cuando un cuerpo entra en el área
func _explosion_effector():
	trigger_explosion()
