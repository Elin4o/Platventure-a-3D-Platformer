extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {}

func _ready():
	load_data()

func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_data = {
			"fullscreen_on" : false,
			"vsync_on" : false,
			"borderless_on":false,
			"master_vol": 0.5,
			"music_vol": 0.5,
			"sfx_vol": 0.5,
			"highscore": 0,
			"time": 60
		}
		save_data()
	file.open(SAVEFILE,File.READ)
	game_data = file.get_var()
	file.close()
	
func save_data():
	var file = File.new()
	file.open(SAVEFILE,File.WRITE)
	file.store_var(game_data)
	file.close()
