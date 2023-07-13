extends CharacterBody3D

@onready var nav : NavigationAgent3D = get_node("NavigationAgent3D")
var speed = 3.0
var gravity = 20
var gravityVector = Vector3()
var howOftenDisparar = 1
var tiempoNextDisparo = 0
var bullet = preload("res://SCENES/bala.tscn");
var shotgunPoint
var animTree

func updatePlayerLocation(targetLocation):
	#print("PlayerLocation: " + str(targetLocation))
	nav.set_target_position(targetLocation)



# Called when the node enters the scene tree for the first time.
func _ready():
	var child = get_child(2)
	animTree = child.get_node("AnimationPlayer")
	shotgunPoint = find_child("BalaSpawnPoint")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var dist = global_transform.origin.distance_to(nav.get_target_position())
	self.look_at(nav.get_target_position())
	
	if is_on_floor():
		gravityVector = Vector3.ZERO
	else:
		gravityVector += Vector3.DOWN * gravity * delta
	
	if(dist > 3): acercarse()
	else: 
		set_velocity(gravityVector)
		move_and_slide()
		if(Time.get_unix_time_from_system() >= tiempoNextDisparo):
			disparar()
		else:
			apuntar()

func apuntar():
	animTree.play("Idle", 1, 1)

func disparar():
	animTree.play("Shoot", 1, 1)
	var b = bullet.instantiate()
	get_parent().get_parent().add_child(b)
	b.global_transform = shotgunPoint.global_transform
	
	tiempoNextDisparo = Time.get_unix_time_from_system() + howOftenDisparar

func acercarse():
	animTree.play("Walk", 1, 1)
	var vel = nav.get_next_path_position() - global_transform.origin
	vel = vel.normalized() * speed
	set_velocity(vel)
	move_and_slide()
