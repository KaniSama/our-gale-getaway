extends Node3D

signal editing_mode_entered
signal gathering_mode_entered
signal resources_updated(_resources : Dictionary)
signal gather_progress_updated(_gather_progress : float)


@onready var modules : Array [ Node3D ]
@onready var resources : Dictionary = {
	"population" = 1,
	"stone" = 0,
	"iron" = 0,
	"wood" = 0,
	"gold" = 0
} :
	get:
		return resources
	set(value):
		resources = value
		emit_signal("resources_updated", resources)
@onready var current_resource : Node3D = null
@onready var current_resources_count : int = 0
@export var gather_speed : float = .1
var gather_progress : float = 0 :
	get:
		return gather_progress
	set(value):
		gather_progress = value
		emit_signal("gather_progress_updated", gather_progress)
@onready var particles = $Armature/Particles
@onready var audio = $SoundPlayer

const states : Dictionary = {
	"standing" : "standing",
	"walking" : "walking",
	"gathering" : "gathering",
	"editing" : "editing"
}
var state : String = states.standing :
	get:
		return state
	set(value):
		state = value
		match state:
			states.editing:
				emit_signal("editing_mode_entered")
			states.gathering:
				emit_signal("gathering_mode_entered")


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
@onready var init_body_rots : Quaternion
@onready var init_body_pos : Vector3

@onready var skeleton = $Armature/Skeleton3D
@onready var collider = $Armature/Skeleton3D/Collisions/Collider
@onready var module_area = $Armature/Skeleton3D/Collisions/ModuleArea


########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	var body = skeleton.find_bone("Body.U")
	init_body_rots = skeleton.get_bone_pose_rotation(body)
	init_body_pos = skeleton.get_bone_pose_position(body)


func _physics_process(delta):
	
	handle_movement(delta)
	calculate_population()
	
	if Input.is_action_just_pressed("mv_edit_mode"):
		match state:
			states.standing:
				state = states.editing
			states.editing:
				state = states.standing
	elif Input.is_action_just_pressed("mv_action"):
		match state:
			states.standing:
				state = states.gathering
			states.gathering:
				state = states.standing
	
	if state == states.gathering:
		gather_resources(delta)
		if current_resources_count > 0:
			particles.emitting = true
	else:
		particles.emitting = false



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass


func handle_movement(delta):
	# Handle movement calculations
	var dir_v : float = Input.get_axis("mv_up", "mv_down")
	var dir_h : float = Input.get_axis("mv_left", "mv_right")
	var dir : Vector2 = Vector2(dir_h, dir_v).normalized()
	
	var body = skeleton.find_bone("Body.R")
	var _lowered : Vector3 = init_body_pos + Vector3(0, -1, 0)
	
	if state in [states.walking, states.standing]:
		move_speed = clampf(
			move_speed + acceleration * (1 if dir_h || dir_v else -1),
			0,
			max_move_speed
		)
		
		velocity = lerp(
			velocity,
			Vector3(dir.x, 0.0, dir.y) * move_speed * delta,
			acceleration
		)
		
		if velocity.length() >= 0.01:
			state = states.walking
		else:
			state = states.standing
		
		# Apply position
		translate(velocity)
		
		# ----Handle rotations
		dish_rotation = Vector2(lookat_back.position.y, lookat_right.position.y)
		dish_rotation += \
			(Vector2(dir_v, dir_h) - dish_rotation) * .05
		lookat_back.position.y = clampf(dish_rotation.x, -max_rots, max_rots)
		lookat_right.position.y = clampf(dish_rotation.y, -max_rots, max_rots)
		# Calculate rotations
		
		tracker_back.look_at(lookat_back.global_position, Vector3.UP)
		tracker_right.look_at(lookat_right.global_position, Vector3.UP)
		
		var new_rots = (Quaternion.from_euler(tracker_back.rotation) * \
			Quaternion.from_euler(tracker_right.rotation)).normalized()
		
		# Apply rotation
		skeleton.set_bone_pose_rotation(body, new_rots)
	
	if state in [states.walking, states.editing, states.standing]:
		# -- Cancel body lowering when no longer gathering resource
		var _new_body_pos = skeleton.get_bone_pose_position(body)
		#_new_body_pos += (init_body_pos - _new_body_pos) * .05
		_new_body_pos += Vector3(0, .01, 0)
		_new_body_pos = _new_body_pos.clamp(_lowered, init_body_pos)
		skeleton.set_bone_pose_position(body, _new_body_pos)
	elif state == states.gathering:
		# -- Handle body lowering when gathering resource
		var _new_body_pos = skeleton.get_bone_pose_position(body)
		#_new_body_pos += ((init_body_pos - Vector3(0, 1, 0)) - _new_body_pos) * .05
		_new_body_pos -= Vector3(0, .01, 0)
		_new_body_pos = _new_body_pos.clamp(_lowered, init_body_pos)
		skeleton.set_bone_pose_position(body, _new_body_pos)
		# Play drilling audio
		audio.stream = load("res://Sound/step_between1.wav")
		if !audio.playing:
			audio.play()

func gather_resources(delta):
	if current_resource != null:
		var _resource_type = current_resource.resource_type
		
		gather_progress += gather_speed * resources.population
		
		if gather_progress >= 1.0:
			gather_progress = 0
			resources[_resource_type] += 1
			update_resources()

func update_resources():
	resources = resources

func calculate_population():
	var _pop = modules.filter(func(x): return x is House).size()
	resources.population = 1 + _pop
	
	update_resources()

func add_module(module : Node3D):
	if module not in modules:
		modules.append(module)


func exit_editing_mode():
	state = states.standing

func make_step_sound():
	audio.stream = [
		load("res://Sound/step1.wav"),
		load("res://Sound/step2.wav"),
		load("res://Sound/step3.wav"),
	].pick_random()
	audio.play()



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_module_area_body_entered(body):
	modules.append(body)
func _on_module_area_body_exited(body):
	modules.erase(body)


func _on_resource_area_area_entered(area):
	if area is ResourceArea:
		current_resource = area.get_parent_node_3d()
		current_resources_count += 1
func _on_resource_area_area_exited(area):
	if area is ResourceArea:
		current_resources_count -= 1
		if current_resources_count <= 0:
			current_resource = null


func _on_leg_f_ik_target_stepped():
	make_step_sound()
func _on_leg_l_ik_target_stepped():
	make_step_sound()
func _on_leg_r_ik_target_stepped():
	make_step_sound()


