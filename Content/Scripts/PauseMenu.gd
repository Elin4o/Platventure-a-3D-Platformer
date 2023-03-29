extends Control

var is_paused = false setget set_is_paused

onready var menu = $CenterContainer
onready var options = $Options
onready var video = $Video
onready var audio = $Audio

onready var fullscreeon_checkbox = $Video/HBoxContainer/Checkboxes/FullScreen
onready var borderless_checkbox= $Video/HBoxContainer/Checkboxes/Borderless
onready var vsync_checkbox = $Video/HBoxContainer/Checkboxes/VSync

onready var master_vol_slider = $Audio/HBoxContainer/Sliders/Master
onready var music_vol_slider = $Audio/HBoxContainer/Sliders/Music
onready var sfx_vol_slider = $Audio/HBoxContainer/Sliders/SoundFX

func _ready():
	fullscreeon_checkbox.pressed = SaveSettings.game_data.fullscreen_on
	GlobalSettings.toggle_fullscreen(SaveSettings.game_data.fullscreen_on)
	vsync_checkbox.pressed = SaveSettings.game_data.vsync_on
	borderless_checkbox.pressed = SaveSettings.game_data.borderless_on
	
	master_vol_slider.value = SaveSettings.game_data.master_vol
	music_vol_slider.value = SaveSettings.game_data.music_vol
	sfx_vol_slider.value = SaveSettings.game_data.sfx_vol

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.is_paused = !is_paused
	
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif is_paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_ResumeBtn_pressed():
	self.is_paused = false


func _on_Options_pressed():
	show_and_hide(options,menu)

func _on_QuitBtn_pressed():
	get_tree().quit()

	
func show_and_hide(first,second):
	first.show()
	second.hide()
	
func _on_Video_pressed():
	show_and_hide(video,options)

func _on_FullScreen_toggled(button_pressed):
	GlobalSettings.toggle_fullscreen(button_pressed)

func _on_Borderless_toggled(button_pressed):
	GlobalSettings.toggle_borderless(button_pressed)

func _on_VSync_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)

func _on_BackFromVideo_pressed():
	show_and_hide(options,video)

func _on_Audio_pressed():
	show_and_hide(audio,options)

func _on_Master_value_changed(value):
	GlobalSettings.update_master_vol(value)

func _on_Music_value_changed(value):
	GlobalSettings.update_music_vol(value)

func _on_SoundFX_value_changed(value):
	GlobalSettings.update_sfx_vol(value)

func _on_BackFromAudio_pressed():
	show_and_hide(options,audio)

func _on_BackFromOptions_pressed():
	show_and_hide(menu,options)

func volume(bus_index,value):
	AudioServer.set_bus_volume_db(bus_index,value)
