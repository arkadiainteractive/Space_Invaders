extends RigidBody3D
class_name Alien

@export var critical_impacts = 1
var mesh_instance
var material
@export var color = Color(0.821, 0.555, 0.66)

# Variables para el comportamiento de los NPC
var initial_position: Vector3
var initial_rotation: Basis  # Para almacenar la orientación inicial
var lateral_speed: float = 5.0
var direction: Vector3 = Vector3.RIGHT # Dirección inicial
var bomb_delay: float = 2.0
var shoot_delay: float = 3.0
var bomb_velocity: Vector3 = Vector3(0, -10, 0) # Velocidad de la bomba hacia abajo
var shoot_velocity: Vector3 = Vector3(0, 0, -20) # Velocidad del disparo hacia el cañón

# Tiempo para controlar los ataques
var bomb_timer: float = 0.0
var shoot_timer: float = 0.0

# Referencia al cañón del protagonista
var player_cannon: Node3D

# Para saber si ha sido desplazado y debe volver a la posición original
var displaced: bool = false

# Inicializamos el NPC
func _ready():
	initial_position = global_position
	initial_rotation = global_transform.basis  # Guardamos la orientación inicial
	bomb_timer = bomb_delay
	shoot_timer = shoot_delay

	$Fragments.connect("destroy", Destroy)
	$Fragments.critical_impacts = critical_impacts
	mesh_instance = $Alien
	material = mesh_instance.mesh.surface_get_material(0)
	material.albedo_color = color

func Destroy():
	queue_free()

# Control del NPC en cada frame
func _process(delta):
	# Movimiento lateral continuo
	move_laterally(delta)
	
	# Ataque de bombardeo (hacia abajo)
	if bomb_timer <= 0:
		#shoot_bomb()
		bomb_timer = bomb_delay
	else:
		bomb_timer -= delta
	
	# Ataque dirigido al cañón del jugador
	if shoot_timer <= 0:
		#shoot_at_player()
		shoot_timer = shoot_delay
	else:
		shoot_timer -= delta

	# Si el NPC fue desplazado, que vuelva a su posición
	if displaced:
		return_to_initial_position(delta)

# Función para mover lateralmente al NPC
func move_laterally(delta):
	# Si no está desplazado, mantenemos el movimiento lateral continuo
	if not displaced:
		var lateral_velocity = direction * lateral_speed
		# Ajusta la velocidad del NPC en el eje X para movimiento lateral continuo
		linear_velocity.x = lateral_velocity.x

		# Cambiar dirección si llega a los límites (definir los límites en tu mundo)
		if global_position.x > 20 or global_position.x < -20:  # Ejemplo de límites
			direction *= -1

# Función para volver a la posición inicial si fue desplazado
func return_to_initial_position(delta):
	# Calculamos la diferencia entre la posición actual y la posición inicial
	var diff = initial_position - global_position

	# Si la diferencia es pequeña, se considera que ha vuelto a su posición
	if diff.length() > 0.1:
		# Ajustamos la velocidad para que vuelva a su posición original
		var return_velocity = diff.normalized() * lateral_speed
		linear_velocity = return_velocity
	else:
		linear_velocity.x = 0
		linear_velocity.z = 0
		linear_velocity.y = 0
		displaced = false

# Función que detecta si el NPC fue empujado por una explosión o colisión
func _integrate_forces(state: PhysicsDirectBodyState3D):
	# Detectamos si fue desplazado de su posición original
	if global_position.distance_to(initial_position) > 5.0:  # Asume que si está a más de 5 unidades fue desplazado
		displaced = true
	
	# Verificamos si la rotación ha cambiado y corregimos la orientación
	var current_rotation = global_transform.basis
	if not current_rotation.is_equal_approx(initial_rotation):
		# Interpolamos hacia la rotación original para que regrese suavemente
		var rotation_diff = current_rotation.slerp(initial_rotation, state.get_step() * 5)  # Aumentar la velocidad de corrección de la rotación
		global_transform.basis = rotation_diff

		# Si el NPC está girando, reducimos la velocidad angular para estabilizarlo
		set_angular_velocity(Vector3.ZERO)
