extends CharacterBody3D

const ACCEL_DEFAULT = 10 # Normal Acceleration
const ACCEL_AIR = 1 # Acceleration in Air

@onready var accel = ACCEL_DEFAULT
@export var shotgunPoint: Node3D
var speed = 2
var gravity = 20
var jump = 8
var mouseSensi = 0.1
var rotationSpeed = 4

var direction = Vector3()
var localVelocity = Vector3()
var gravityVec = Vector3()
var movement = Vector3()

var vidaLabel : Label
var bullet = preload("res://SCENES/bala.tscn");
var animTree

var vida = 100


func _ready():
	
	animTree = get_node("Character/AnimationPlayer")
	vidaLabel = get_node("/root/GameControl/CanvasLayer/VidaValue")
	vidaLabel.text = str(vida)

func _input(event):
	#Rotation with mouse because we cant get this in physics process
	if (event is InputEventMouseMotion ):
		self.rotate_y(deg_to_rad(-event.relative.x * mouseSensi))

#func _process(delta):

func _physics_process(delta):
	direction = Vector3.ZERO
	var hRot = global_transform.basis.get_euler().y # Horizontal Rotation

	# Forward & Backward Input
	var fInput = Input.get_action_strength("mvBackward") - Input.get_action_strength("mvForward")
	var hInput = Input.get_action_strength("mvRight") - Input.get_action_strength("mvLeft")
	
	#animate walk
	if(fInput != 0 or hInput != 0): 
		animTree.play("Walk", 1, 1)
	else:
		animTree.play("Idle", 1, 1)
	
	#rotation with keys
	if (Input.is_action_pressed("rotLeft")):
		self.rotate_y(deg_to_rad(rotationSpeed))
	elif (Input.is_action_pressed("rotRight")):
		self.rotate_y(deg_to_rad(-rotationSpeed))


	direction = Vector3(hInput, 0, fInput).rotated(Vector3.UP, hRot).normalized()

	if is_on_floor():
		accel = ACCEL_DEFAULT
		gravityVec = Vector3.ZERO
	else:
		accel = ACCEL_AIR
		gravityVec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("mvJump") and is_on_floor():
		gravityVec = Vector3.UP * jump
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# Move
	localVelocity = localVelocity.lerp(direction * speed, accel * delta)
	movement = localVelocity + gravityVec

	# warning-ignore:return_value_discarded
	set_velocity(movement)
	move_and_slide()


func shoot():
	animTree.play("Shoot", 1, 1)
	var b = bullet.instantiate()
	get_parent().get_parent().add_child(b)
	b.global_transform = shotgunPoint.global_transform
	
func hit():
	animTree.play("Hurt", 1, 1)
	vida = vida - 10
	vidaLabel.text = str(vida)
	if(vida <= 0):
		get_tree().change_scene_to_file("res://SCENES/Muerto.tscn")
		#queue_free() #Morto bien morto
