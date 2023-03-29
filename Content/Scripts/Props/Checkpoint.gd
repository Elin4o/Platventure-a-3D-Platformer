extends Spatial

var respawn_pos
var is_current_checkpoint = false

onready var flag_color = $Flag/Flag_Bool.get_surface_material(0)

func _process(delta):
	if is_current_checkpoint:
		flag_color.albedo_color = Color(0, 1, 0)
		$Flag/Flag_Bool.set_surface_material(0, flag_color)
	else:
		flag_color.albedo_color = Color(1, 1, 1)
		$Flag/Flag_Bool.set_surface_material(0, flag_color)

func _ready():
	respawn_pos = $RespawnPoint.get_global_transform().origin

func _on_Area_body_entered(body):
	if body.has_method("set_checkpoint"):
		if !is_current_checkpoint:
			body.set_checkpoint(respawn_pos,self)
			print("true")
			
