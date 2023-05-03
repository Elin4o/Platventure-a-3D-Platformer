extends Node

var next_level = null

onready var current_level = $Level_Menu
onready var anim = $AnimationPlayer

func _ready():
	current_level.connect("level_changed",self,"handle_level_changed")
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size() 
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func handle_level_changed(current_level_name: String):
	var next_level_name: String 
	
	match current_level_name:
		"Menu":
			next_level_name = "Intro"
		"Intro":
			next_level_name = "01"	
		"01":
			next_level_name = "02"	
		"02":
			next_level_name = "03"	
		"03":
			next_level_name = "04"	
		"04":
			next_level_name = "Credits"
		"Credits":
			next_level_name = "Menu"
		_:
			return
			
	next_level = load("res://Content/Scenes/Levels/Level_" + next_level_name + ".tscn").instance()
	next_level.hide()
	add_child(next_level)
	anim.play("fade_in")
	
	next_level.connect("level_changed",self,"handle_level_changed")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			current_level.queue_free()
			current_level = next_level
			current_level.show()
			next_level = null
			
			anim.play("fade_out")
		"fade_out":
			pass
			
		
			
