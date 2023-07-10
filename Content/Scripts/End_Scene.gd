extends CanvasLayer

signal level_changed(level_name)

export (String) var level_name = "level"

var highscore = SaveSettings.game_data.highscore
var current_time_text = GlobalSettings.time_passed
var current_time_float = GlobalSettings.time
var best_time = SaveSettings.game_data.time

func _ready():
	
	if GlobalSettings.score > highscore :
		highscore = GlobalSettings.score
		GlobalSettings.update_highscore(highscore)
		
	if current_time_float < best_time:
		best_time = current_time_float
		GlobalSettings.update_best_time(best_time)
		
	var miliseconds = fmod(best_time,1)*100
	var seconds = fmod(best_time,60)
	var minutes = fmod(best_time,60*60)/60
	
	var best_time_passed = "%02d:%02d:%02d" % [ minutes , seconds, miliseconds]
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MenuControl/Menu/VBoxContainer/ScoreContainer/Score.text = "Score: " + String(GlobalSettings.score)
	$MenuControl/Menu/VBoxContainer/ScoreContainer/Highscore.text = "Highscore: "  + String(highscore)
	$MenuControl/Menu/VBoxContainer/TimeContainer/CurrentTime.text = "Current time: " + String(current_time_text)
	$MenuControl/Menu/VBoxContainer/TimeContainer/BestTime.text = "Best Time: " + String(best_time_passed)

func _on_Menu_Button_pressed():
	emit_signal("level_changed",level_name)


func _on_Exit_pressed():
	get_tree().quit()
