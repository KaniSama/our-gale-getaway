extends Node3D

@onready var state : String = "standing"


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	pass



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func set_state(_new_state : String):
	state = _new_state

func get_state() -> String:
	return state

func is_editing() -> bool:
	return state == "editing"



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
