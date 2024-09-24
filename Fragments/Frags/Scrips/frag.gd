extends Node3D

var frag_scene
var frag_instance

func _ready() -> void:
	frag_scene = load("res://Fragments/BasicFragment/Scenes/basic_fragment.tscn")
	$"..".connect("exploded", _on_exploded_signal)

func Start() -> void:
	frag_instance = frag_scene.instantiate()
	frag_instance.position = global_position
	get_tree().current_scene.add_child(frag_instance)
	frag_instance.set_scale(scale)


func _on_exploded_signal():
	Start()
