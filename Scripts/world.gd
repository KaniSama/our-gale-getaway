extends Node3D

@onready var cam = $Camera3D
@onready var dish = $Dish
@onready var init_cam_pos : Vector3


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	init_cam_pos = cam.global_position


func _physics_process(delta):
	cam.global_position += \
		((dish.global_position + init_cam_pos) - \
		cam.global_position) * .05



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func help():
	pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
