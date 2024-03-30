extends MeshInstance3D

@onready var spd = .3

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _process(delta):
	var dir = Vector3(0, Input.get_axis("np_8", "np_2"), 0).normalized()
	position += dir * spd



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
