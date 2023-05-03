extends CanvasLayer

onready var menu = $MenuControl/Menu
onready var options = $MenuControl/Options
onready var video = $MenuControl/Video
onready var audio = $MenuControl/Audio

onready var fullscreeon_checkbox = $MenuControl/Video/HBoxContainer/Checkboxes/FullScreen
onready var borderless_checkbox= $MenuControl/Video/HBoxContainer/Checkboxes/Borderless
onready var vsync_checkbox = $MenuControl/Video/HBoxContainer/Checkboxes/VSync

onready var master_vol_slider = $MenuControl/Audio/HBoxContainer/Sliders/Master
onready var music_vol_slider = $MenuControl/Audio/HBoxContainer/Sliders/Music
onready var sfx_vol_slider = $MenuControl/Audio/HBoxContainer/Sliders/SoundFX

signal level_changed(level_name)

export (String) var level_name = "level"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MenuControl/Menu/VBoxContainer/Start_Button.disabled = false
	$MenuControl/Menu/VBoxContainer/Options.disabled = false
	$MenuControl/Menu/VBoxContainer/Exit.disabled = false
	
	fullscreeon_checkbox.pressed = SaveSettings.game_data.fullscreen_on
	GlobalSettings.toggle_fullscreen(SaveSettings.game_data.fullscreen_on)
	vsync_checkbox.pressed = SaveSettings.game_data.vsync_on
	borderless_checkbox.pressed = SaveSettings.game_data.borderless_on
	
	master_vol_slider.value = SaveSettings.game_data.master_vol
	music_vol_slider.value = SaveSettings.game_data.music_vol
	sfx_vol_slider.value = SaveSettings.game_data.sfx_vol
	
	
func _on_Start_Button_pressed():
	emit_signal("level_changed",level_name)
	$MenuControl/Menu/VBoxContainer/Start_Button.disabled = true
	$MenuControl/Menu/VBoxContainer/Options.disabled = true
	$MenuControl/Menu/VBoxContainer/Exit.disabled = true
	GlobalSettings.score = 0


func _on_Options_pressed():
	play_soundFX()
	show_and_hide(options,menu)


func _on_Exit_pressed():
	get_tree().quit()


func show_and_hide(first,second):
	first.show()
	second.hide()


func _on_Video_pressed():
	play_soundFX()
	show_and_hide(video,options)

func _on_FullScreen_toggled(button_pressed):
	play_soundFX()
	GlobalSettings.toggle_fullscreen(button_pressed)

func _on_Borderless_toggled(button_pressed):
	play_soundFX()
	GlobalSettings.toggle_borderless(button_pressed)

func _on_VSync_toggled(button_pressed):
	play_soundFX()
	GlobalSettings.toggle_vsync(button_pressed)

func _on_BackFromVideo_pressed():
	play_soundFX()
	show_and_hide(options,video)

func _on_Audio_pressed():
	play_soundFX()
	show_and_hide(audio,options)

func _on_Master_value_changed(value):
	GlobalSettings.update_master_vol(value)

func _on_Music_value_changed(value):
	GlobalSettings.update_music_vol(value)

func _on_SoundFX_value_changed(value):
	GlobalSettings.update_sfx_vol(value)

func _on_BackFromAudio_pressed():
	play_soundFX()
	show_and_hide(options,audio)

func _on_BackFromOptions_pressed():
	play_soundFX()
	show_and_hide(menu,options)

func play_soundFX():
	$Click.play()
