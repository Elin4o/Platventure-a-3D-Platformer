extends Node

var score = 0
var time = 0
var time_passed
var timer_on = false

func _process(delta):
	if timer_on == true :
		time += delta
		
	convert_time()

func toggle_fullscreen(value):
	OS.window_fullscreen = value
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size() 
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	SaveSettings.game_data.fullscreen_on = value
	SaveSettings.save_data()
	
func toggle_vsync(value):
	OS.vsync_enabled = value
	SaveSettings.game_data.vsync_on = value
	SaveSettings.save_data()
	
func toggle_borderless(value):
	OS.window_borderless = value
	SaveSettings.game_data.borderless_on = value
	SaveSettings.save_data()
	
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(vol))
	SaveSettings.game_data.master_vol = vol
	SaveSettings.save_data()
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(vol))
	SaveSettings.game_data.music_vol = vol
	SaveSettings.save_data()
	
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear2db(vol))
	SaveSettings.game_data.sfx_vol = vol
	SaveSettings.save_data()

func update_highscore(highscore):
	SaveSettings.game_data.highscore = highscore
	SaveSettings.save_data()

func update_best_time(new_best_time):
	SaveSettings.game_data.time = new_best_time
	SaveSettings.save_data()

func convert_time():
	var miliseconds = fmod(time,1)*100
	var seconds = fmod(time,60)
	var minutes = fmod(time,60*60)/60
	
	time_passed = "%02d:%02d:%02d" % [ minutes , seconds, miliseconds]
