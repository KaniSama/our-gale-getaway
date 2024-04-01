extends RigidBody3D
class_name Turret

var grabable : bool = false


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _physics_process(delta):
	grabable = get_parent().is_editing()



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass


func _on_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("ui_lmb"):
		position -= Vector3(0, 1, 0)

