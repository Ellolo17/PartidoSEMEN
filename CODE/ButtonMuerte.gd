extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("ui_cancel")
	or Input.is_action_just_pressed("uiB")):
		get_tree().quit()
	pass


func _on_pressed():
	get_tree().change_scene_to_file("res://SCENES/Juego.tscn")
