extends Marker3D

@export var step_target : Marker3D
@export var step_distance : float = 3.0

@export var adjacent_target : Marker3D
var is_stepping : bool = false


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _process(delta):
	if (!is_stepping && !adjacent_target.is_stepping
		&& abs(
			global_position.distance_to(step_target.global_position)
		) > step_distance
	):
		step()



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func step():
	var target_pos = step_target.global_position
	var halfway = (global_position + target_pos) / 2
	
	is_stepping = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", halfway + owner.basis.y, .1)
	tween.tween_property(self, "global_position", target_pos, .07)
	
	tween.tween_callback(func(): is_stepping = false)

