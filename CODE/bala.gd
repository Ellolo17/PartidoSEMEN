extends Area3D

var speed = 120
var lifeTime = 5000 #5 seconds
var deadTime
var audioPlayer :AudioStreamPlayer3D
var sonidoMuerte : AudioStreamPlayer3D
var particulas : GPUParticles3D


func _ready():
	audioPlayer = get_node("AudioStreamPlayer3D")
	particulas = get_node("GPUParticles3D")
	audioPlayer.play(0)
	sonidoMuerte = get_node("SonidoMuerte")
	deadTime = Time.get_unix_time_from_system() + lifeTime;

func _physics_process(delta):
	if(Time.get_unix_time_from_system() > deadTime):
		queue_free()
	move(speed * delta)
	
func move(mod):
	var vek = Vector3(0,0,1) * mod
	var newTrans = transform.translated_local(vek)
	transform = newTrans

func _on_Bullet_body_entered(body):
	particulas.emitting = true
	if body.is_in_group("enemigos"):
		sonidoMuerte.play(0)
		var root = get_node("/root/GameControl")
		root.enemigoMuerto()
		body.animTree.play("Die", 1, 1)
		body.queue_free()
	if( body.is_in_group("Jugador")):
		body.hit()
	


func _on_sonido_muerte_finished():
	queue_free()
