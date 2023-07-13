extends CharacterBody3D

@export var cameraPivot: Node3D
@export var objectToFollow: Node3D
@export var camAccel = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	# look at target
	self.look_at(objectToFollow.global_position)
	
	# move to position
	var mov = cameraPivot.global_position - self.global_position 
	#var movement = self.global_position.lerp(cameraPivot.global_position, delta * camAccel)
	set_velocity(mov)
	move_and_slide()
	
