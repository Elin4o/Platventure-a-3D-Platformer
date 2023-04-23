extends Node

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
