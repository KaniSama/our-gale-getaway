extends RayCast3D

@export var step_target : Marker3D

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _physics_process(delta):
	var hit_point = get_collision_point()
	
	if (hit_point):
		step_target.global_position = hit_point


