extends Node3D

@export var max_move_speed : float = 5.0
@export var acceleration : float = .05
var move_speed : float = 0
var velocity : Vector3 = Vector3.ZERO


@export var tracker_back : Node3D
@export var tracker_right : Node3D
@export var lookat_back : Node3D
@export var lookat_right : Node3D
var dish_rotation : Vector2 = Vector2.ZERO
const max_rots = .5

@onready var skeleton = $Armature/Skeleton3D
@onready var collider = $Armature/Skeleton3D/Collisions/Collider

@onready var init_body_rots : Quaternion

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	var body = skeleton.find_bone("Body.U")
	init_body_rots = skeleton.get_bone_pose_rotation(body)


func _physics_process(delta):
	
	
	handle_movement(delta)



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func handle_movement(delta):
	# Handle movement calculations
	var dir_v : float = Input.get_axis("ui_up", "ui_down")
	var dir_h : float = Input.get_axis("ui_left", "ui_right")
	var dir : Vector2 = Vector2(dir_h, dir_v).normalized()
	
	move_speed = clampf(move_speed + acceleration * (1 if dir_h || dir_v else -1), 0, max_move_speed)
	
	velocity = lerp(velocity, Vector3(dir.x, 0.0, dir.y) * move_speed * delta, acceleration)
	
	# Apply position
	translate(velocity)
	
	# ----Handle rotations
	dish_rotation = Vector2(lookat_back.position.y, lookat_right.position.y)
	dish_rotation += \
		(Vector2(dir_v, dir_h) - dish_rotation) * .05
	lookat_back.position.y = clampf(dish_rotation.x, -max_rots, max_rots)
	lookat_right.position.y = clampf(dish_rotation.y, -max_rots, max_rots)
	# Calculate rotations
	var body = skeleton.find_bone("Body.R")
	
	tracker_back.look_at(lookat_back.global_position, Vector3.UP)
	tracker_right.look_at(lookat_right.global_position, Vector3.UP)
	
	var new_rots = (Quaternion.from_euler(tracker_back.rotation) * Quaternion.from_euler(tracker_right.rotation)).normalized()
	
	# Apply rotation
	skeleton.set_bone_pose_rotation(body, new_rots)
	#collider.rotation = -new_rots.get_euler(2)



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_child_key_pressed():
	pass
