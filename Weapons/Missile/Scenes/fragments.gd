extends Node3D

signal missile_explosion
signal missile_destroyed
var impact_counter = 0
var critical_impacts

@onready var explosion_scene = preload("res://Weapons/Missile/Scenes/explosion.tscn")
var explosion_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explosion_instance = explosion_scene.instantiate() # Instancia la escena

func Destroy():
	explosion_instance.global_transform.origin = $"../ExplosionPosition".global_position # Posiciona la explosión
	get_tree().root.add_child(explosion_instance) # Añádela como hijo del árbol de nodos
	emit_signal("missile_explosion")
	emit_signal("missile_destroyed")

func _create_fragments(body: Node3D) -> void:
	Destroy()
