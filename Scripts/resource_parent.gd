extends Node3D

@export var resource_type : String
@onready var resource = $Resource


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	rotation_degrees = Vector3(0,randf_range(0,359.9),0)
	
	var _meshes = get_children().filter(func(x): return x is MeshInstance3D)
	for __i in _meshes:
		__i.visible = false
	_meshes.pick_random().visible = true



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func get_resource_type() -> String:
	return resource_type



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
