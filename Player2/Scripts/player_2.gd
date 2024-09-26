extends Node3D
class_name Player3person

# Referencia al nodo de la cámara
#@onready var camera : PhantomCamera3D = $PhantomCamera3D
@onready var camera : Camera3D = $Camera3D
# Referencia al nodo del cañón
@onready var cannon : CharacterBody3D = $Cannon
# Referencia al nodo de la mira
@onready var aim_control_scene : PackedScene = load ("res://Aim/Scenes/aim.tscn")
var aim_control: Control
 
func _ready():
	print ("caca")
# Asegurarse de que la escena de la mira está asignada
	if aim_control_scene:
		# Instanciar la escena de la mira
		var aim_control_instance = aim_control_scene.instantiate()
		print ("AIM_CONTROL_INSTANCE: ", aim_control_instance)

		# Agregar la instancia de la mira a la escena actual (puedes agregarla al root o a un CanvasLayer existente)
		get_tree().root.add_child(aim_control_instance)

		# Obtener el nodo Control de la instancia de la mira
		aim_control = aim_control_instance.get_node("AimControl") # Replace "Control" with the actual name of your Control node if different

		print("Mira inicializada correctamente: ", aim_control)
	else:
		print("Error: La escena de la mira no está asignada.")

func _process(delta):
	if aim_control != null:
		# Get the mouse position in the viewport
		var mouse_position = get_viewport().get_mouse_position()

		# Convert the screen position to a 3D ray from the camera
		var from = camera.project_ray_origin(mouse_position)
		var direction = camera.project_ray_normal(mouse_position)

		# Define a distant point in the ray's direction
		var target_position = from + direction * 1000

		# Orient the cannon towards the 3D target position (no restriction on y-axis)
		cannon.look_at(target_position)
	else:
		print("Error: aim_control es null.")
