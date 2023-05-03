extends Spatial

var respawn_pos
var is_current_checkpoint = false
var triggered_up = false
var triggered_down = false

onready var anim_player = $AnimationPlayer

func _ready():
	respawn_pos = $RespawnPoint.get_global_transform().origin

func _process(_delta):
	should_anim_play()
		

func _on_Area_body_entered(body):
	if body.has_method("set_checkpoint"):
		if !is_current_checkpoint:
			body.set_checkpoint(respawn_pos,self)
			triggered_down = false
			triggered_up = false
			$FlagUp.play()
		
			
func should_anim_play():
	if is_current_checkpoint == true:
		if !triggered_up:
			triggered_up = true
			anim_player.play("FlagUp")		
	else:
		if !triggered_down:
			triggered_down = true
			anim_player.play("RESET")		
