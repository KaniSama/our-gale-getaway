extends Node3D

@export var wind_force : float = 5.0

@onready var modules_inside : Array[Node3D] = []
@onready var aim : Basis
@onready var forward : Vector3

########################################### OVERRIDES
func _____OVERRIDES(): pass


func _ready():
	aim = get_global_transform().basis
	forward = aim.z

func _physics_process(delta):
	for __i in modules_inside:
		if __i is RigidBody3D:
			__i.apply_central_force((forward).normalized() * wind_force)



########################################### HELPER FUNCTIONS
func _____HELPERS(): pass



########################################### SIGNALS
func _____SIGNALS(): pass


func _on_area_3d_body_entered(body):
	modules_inside.append(body)


func _on_area_3d_body_exited(body):
	modules_inside.erase(body)
