extends Node3D

@onready var cam = $Player/Camera3D
@onready var cam_edit_mode = $Player/Camera3DEditMode
@onready var cam_offset : Vector3
@onready var dish = $Player/Dish
@onready var init_cam_pos : Vector3
@onready var init_cam_rots : Vector3
var cam_shake = {
	"frames" : 0,
	"intensity" : .01
}
@onready var modules = $Player/Modules
@onready var bulding_menu = $Player/Camera3D/CanvasLayer/HUD/BuildingMenu
@onready var resource_grid = $Player/Camera3D/CanvasLayer/HUD/ResourceGrid
@onready var stats_grid = $Player/Camera3D/CanvasLayer/HUD/StatsGrid
@onready var gather_progress_bar = $Player/Camera3D/CanvasLayer/HUD/ResourceGatherProgressBar


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
	init_cam_rots = cam.global_rotation
	cam_offset = cam_edit_mode.global_position - cam.global_position


func _physics_process(delta):
	modules.set_state(dish.state)
	if dish.state != dish.states.editing:
		cam.global_position += \
		((dish.global_position + init_cam_pos) - \
		cam.global_position) * .05 + \
		Vector3(
			randf_range(-1, 1) * cam_shake["intensity"] * cam_shake["frames"],
			0,
			randf_range(-1, 1) * cam_shake["intensity"] * cam_shake["frames"]
		)
		cam.global_rotation = lerp(
			cam.global_rotation,
			init_cam_rots,
			.15
		)
		
		cam_edit_mode.global_position = cam.global_position + cam_offset
	else:
		cam.global_position = lerp(
			cam.global_position,
			dish.global_position + init_cam_pos + cam_offset,
			.33
		)
		cam.global_rotation = lerp(
			cam.global_rotation,
			cam_edit_mode.global_rotation,
			.33
		)
	
	gather_progress_bar.visible = dish.state == dish.states.gathering
	bulding_menu.visible = dish.state == dish.states.editing
	
	cam_shake["frames"] = clamp(cam_shake["frames"] - 1, 0, 1000)
	
	if (dish.state == dish.states.gathering):
		shake_cam(1)



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


func _on_dish_resources_updated(_resources : Dictionary):
	for __i in _resources.keys():
		var __res = resource_grid.find_child(
			__i.capitalize() + "Label"
		)
		if __res:
			__res.text = str(_resources[__i])
	
	stats_grid.find_child("PopulationLabel").text = "Population: " + \
		str((_resources.population - 1) * 10 + 1)

func _on_dish_gather_progress_updated(_gather_progress):
	gather_progress_bar.value = _gather_progress
