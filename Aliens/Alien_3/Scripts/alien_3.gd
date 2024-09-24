extends Node3D

@export var critical_impacts = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RigidBody3D/Fragments.connect("destroy", Desctroy)
	$RigidBody3D/Fragments.critical_impacts = critical_impacts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Desctroy ():
	queue_free()
