extends Node3D

@export var move_speed : float = 5.0
#@export var turn_speed : float = 1.0
@export var tracker_back : Node3D
@export var tracker_right : Node3D
@export var lookat_back : Node3D
@export var lookat_right : Node3D

@onready var skeleton = $Armature/Skeleton3D
@onready var init_body_rots : Quaternion

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	var body = skeleton.find_bone("Body.U")
	init_body_rots = skeleton.get_bone_pose_rotation(body)
	var buf = init_body_rots.get_euler()

func _physics_process(delta):
	
	
	handle_movement(delta)



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func handle_movement(delta):
	# Handle movement itself
	var dir_v : float = Input.get_axis("ui_up", "ui_down")
	var dir_h : float = Input.get_axis("ui_left", "ui_right")
	var dir : Vector2 = Vector2(dir_h, dir_v).normalized()
	
	# ----Handle rotations
	# TODO: Manage rotation markers
	# Calculate rotations
	var body = skeleton.find_bone("Body.R")
	
	tracker_back.look_at(lookat_back.global_position, Vector3.UP)
	tracker_right.look_at(lookat_right.global_position, Vector3.UP)
	
	var new_rots = (Quaternion.from_euler(tracker_back.rotation) * Quaternion.from_euler(tracker_right.rotation)).normalized()
	
	# Apply rotation
	skeleton.set_bone_pose_rotation(body, new_rots)
	
	# Apply position
	translate(Vector3(dir.x, 0.0, dir.y) * move_speed * delta)



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
