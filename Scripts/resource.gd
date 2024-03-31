extends Node3D
class_name ResourceArea

var resource_type : String = ""


@onready var resource_sprite : Node3D = $Sprite3D

@onready var init_sprite_pos : Vector3
var sprite_sin_angle : float = 0


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	resource_type = get_parent().get_resource_type()
	var _resource_icons = find_parent("World").get_resource_icons()
	
	resource_sprite.texture = _resource_icons[resource_type]
	
	init_sprite_pos = resource_sprite.position

func _process(delta):
	sprite_sin_angle += 2
	resource_sprite.position.y = \
		init_sprite_pos.y + sin(deg_to_rad(sprite_sin_angle)) * .33



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
