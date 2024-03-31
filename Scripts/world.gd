extends Node3D

@onready var cam = $Player/Camera3D
@onready var dish = $Player/Dish
@onready var init_cam_pos : Vector3
var cam_shake = {
	"frames" : 0,
	"intensity" : .01
}


const resource_variants : Dictionary = {
	"gold" = [
		preload("res://Models/Resource_Gold_1.blend"),
		preload("res://Models/Resource_Gold_2.blend"),
		preload("res://Models/Resource_Gold_3.blend")
	],
	"stone" = [
		preload("res://Models/Resource_Rock_1.blend"),
		preload("res://Models/Resource_Rock_2.blend"),
		preload("res://Models/Resource_Rock_3.blend")
	],
	"wood" = [
		preload("res://Models/Resource_Tree1.blend"),
		preload("res://Models/Resource_Tree2.blend"),
		preload("res://Models/Resource_Tree_Group.blend"),
		preload("res://Models/Resource_Tree_Group_Cut.blend")],
	"iron" = [
		preload("res://Models/Mine.blend")
	]
}
const resource_icons : Dictionary = {
	"gold" = preload("res://Models/textures/ResourceSprites/gold.png"),
	"stone" = preload("res://Models/textures/ResourceSprites/stone.png"),
	"wood" = preload("res://Models/textures/ResourceSprites/wood.png"),
	"iron" = preload("res://Models/textures/ResourceSprites/iron.png")
}


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	init_cam_pos = cam.global_position


func _physics_process(delta):
	cam.global_position += \
		((dish.global_position + init_cam_pos) - \
		cam.global_position) * .05 + \
		Vector3(
			randf_range(-1, 1) * cam_shake["intensity"] * cam_shake["frames"],
			0,
			randf_range(-1, 1) * cam_shake["intensity"] * cam_shake["frames"]
		)
	
	cam_shake["frames"] = clamp(cam_shake["frames"] - 1, 0, 1000)
	
	if (Input.is_action_just_pressed("ui_accept")):
		shake_cam(15)



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func shake_cam(frames : int = 30):
	cam_shake["frames"] = frames

func get_resource_variants() -> Dictionary:
	return resource_variants
func get_resource_icons() -> Dictionary:
	return resource_icons



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
