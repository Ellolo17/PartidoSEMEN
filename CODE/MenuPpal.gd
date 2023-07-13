extends Node2D

var startTime #Para que al volver de las instrucciones no se vaya  # automaticamente fuera
# Ca
func _ready():
	startTime = Time.get_unix_time_from_system() + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Time.get_unix_time_from_system() > startTime):
		if(Input.is_action_pressed("instructions")):
			buttonInstrucciones();
		if(Input.is_action_pressed("uiA")):
			buttonEmpezar(); #Boton a
		if(Input.is_action_pressed("uiB")):
			buttonSalir(); #boton b
	
	pass


func buttonSalir():
	get_tree().quit()
	

func buttonEmpezar():
	get_tree().change_scene_to_file("res://SCENES/Juego.tscn")
	
func buttonInstrucciones():
	get_tree().change_scene_to_file("res://SCENES/instrucciones.tscn")

