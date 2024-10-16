extends CharacterBody3D

const SPEED = 5.0
const VELOCITY = 20
var color : Color = Color (1, 0, 0)
var particle_system

func _ready() -> void:
	var particle_system = $CollisionShape3D/GPUParticles3D

	# Obtén o crea un material de proceso
	var material = particle_system.process_material as ParticleProcessMaterial
	if material == null:
		material = ParticleProcessMaterial.new()
		particle_system.process_material = material

	# Crear un gradiente
	var gradient = Gradient.new()

	# Configura los colores del gradiente (transición de rojo a azul, por ejemplo)
	gradient.add_point(0.0, Color(1.0, 0.0, 0.0))  # Rojo al inicio
	gradient.add_point(1.0, Color(1.0, 0.0, 1.0))  # Azul al final

	# Asigna el gradiente al material
	material.color_ramp = gradient

func _physics_process(delta: float) -> void:
	move_and_slide()

func set_color (new_color : Color):
	color = new_color

func get_color ():
	return color

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_3d_body_exited(body: Node3D) -> void:
	queue_free()

func Destroy():
	pass
