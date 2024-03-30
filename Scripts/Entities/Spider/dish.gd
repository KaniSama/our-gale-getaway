extends Node3D

@export var move_speed : float = 5.0
#@export var turn_speed : float = 1.0

@onready var skeleton = $Armature/Skeleton3D
@onready var init_body_rots : Quaternion

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	var body = skeleton.find_bone("Body")
	init_body_rots = skeleton.get_bone_pose_rotation(body)
	var buf = init_body_rots.get_euler()

func _physics_process(delta):
	
	
	handle_movement(delta)



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func handle_movement(delta):
	var dir_v : float = Input.get_axis("ui_up", "ui_down")
	var dir_h : float = Input.get_axis("ui_left", "ui_right")
	var dir : Vector2 = Vector2(dir_h, dir_v).normalized()
	
	var body = skeleton.find_bone("Body")
	var rots : Quaternion = skeleton.get_bone_pose_rotation(body)
	rots = rots.slerp(Quaternion(1,0,0,0), .05)
	skeleton.set_bone_pose_rotation(body, rots)
	
	translate(Vector3(dir.x, 0.0, dir.y) * move_speed * delta)



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
