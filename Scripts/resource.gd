extends Node3D

@export var mesh_blend : PackedScene
var resource_type : String = ""

@onready var resource_sprite = $Sprite3D


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	resource_type = get_parent().get_resource_type()
	var _resource_icons = find_parent("World").get_resource_icons()
	
	resource_sprite.texture = _resource_icons[resource_type]



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
