extends Node3D

@onready var cam = $Player/Camera3D
@onready var dish = $Player/Dish
@onready var init_cam_pos : Vector3
var cam_shake = {
	"frames" : 0,
	"intensity" : .01
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



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
