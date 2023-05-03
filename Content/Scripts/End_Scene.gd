extends CanvasLayer

signal level_changed(level_name)

export (String) var level_name = "level"

var highscore = GlobalSettings.score

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MenuControl/Menu/VBoxContainer/Score.text = "Score: " + String(highscore)


func _on_Menu_Button_pressed():
	emit_signal("level_changed",level_name)


func _on_Exit_pressed():
	get_tree().quit()
