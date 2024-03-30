extends MeshInstance3D

@onready var mat

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	mat = material_override

func _process(delta):
	var _pos = global_position
	var _surf = get_surface_override_material(0)
	_surf.uv1_offset = -Vector3(_pos.x,_pos.z,_pos.y) / mesh.size.x



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
