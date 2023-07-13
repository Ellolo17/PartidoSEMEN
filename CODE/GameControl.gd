extends Node3D

var points
var urnsInMap
var time
@export var howOftenRespawnEnemies : float
@export var howManyEnemies : int
@export var howManyUrns : int

var enemigos :Array[PackedScene] = [
	preload("res://SCENES/Enemigo1984.tscn"),
	preload("res://SCENES/EnemigoCulturaLiberal.tscn"),
	preload("res://SCENES/EnemigoFranco.tscn"),
	preload("res://SCENES/EnemigoNato.tscn"),
	preload("res://SCENES/EnemigoOBO.tscn")
]
var enemySpawnPoints: Array[Node3D] = []
var urnaSpawnPoints : Array[Node3D] = []
@export var urnaPrefab : PackedScene
@export var jugador : Node3D
@export var puntosLabel : Label

func enemigoMuerto():
	points += 1
	puntosLabel.text = str(points)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	jugador = jugador.get_node("CharacterBody3D")
	points = 0
	time = Time.get_unix_time_from_system() + howOftenRespawnEnemies;
	$AudioStreamPlayer.play()
	
	getEnemySpawnPoints()
	getUrnaSpawnPoints()
	#Add urn
	#var newUrn = urnPrefab.instance()
	#add_child(newUrn)

func getEnemySpawnPoints():
	var spawnPoint1 = get_node("EnemySpawnPoints/1")
	var spawnPoint2 = get_node("EnemySpawnPoints/2")
	enemySpawnPoints.append(spawnPoint1)
	enemySpawnPoints.append(spawnPoint2)

func getUrnaSpawnPoints():
	var spawnPoint1 = get_node("VotoSpawnPoints/1")
	var spawnPoint2 = get_node("VotoSpawnPoints/2")
	urnaSpawnPoints.append(spawnPoint1)
	urnaSpawnPoints.append(spawnPoint2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()
	
	if(time < Time.get_unix_time_from_system()):
		respawnEnemies()
		time = Time.get_unix_time_from_system() + howOftenRespawnEnemies;
	pass

func respawnEnemies():
	for i in howManyEnemies:
		var enemyIndex =  randi() % enemigos.size()
		var spawnIndex = randi() % enemySpawnPoints.size()
		
		var newEnemy = enemigos[enemyIndex].instantiate()
		add_child(newEnemy)
		
		print("spawned enemy at " + str(newEnemy.global_transform ) + " - Spawn position " + str(spawnIndex))
		newEnemy.global_position = enemySpawnPoints[spawnIndex].global_position
		newEnemy.global_scale( Vector3(1.3, 1.3, 1.3)) 
		

func _physics_process(delta):
	get_tree().call_group("enemigos", "updatePlayerLocation",jugador.global_transform.origin)
