extends CharacterBody3D

@export var color = Color(0.8, 0.745, 0.443)

const SPEED = 5.0
const VELOCITY = 10
var target : Area3D

var speed: float = 10.0  # Velocidad del misil
var turn_speed: float = 3.0  # Velocidad de giro del misil

func _ready() -> void:
	$Fragments.connect("missile_destroyed", _on_missile_destroyed_signal)
	#pass

func set_target(target_area: Area3D):
	target = target_area

func _physics_process(delta):
	if target and is_instance_valid(target):
		# Convertir la posición 3D del objetivo a 2D extrayendo los componentes x e y
		# Convertir la posición 3D del objetivo a 2D extrayendo los componentes x y z
		# Obtener la posición del objetivo
		var target_position = target.global_transform.origin

		# Orientar el misil hacia el objetivo usando look_at
		look_at(target_position, Vector3.UP)

		# Calcular la dirección hacia el objetivo
		var direction = (target_position - global_transform.origin).normalized()

		# Mover el misil hacia el objetivo
		global_translate(direction * speed * delta)
		move_and_slide()

func _on_missile_destroyed_signal():
	queue_free()
