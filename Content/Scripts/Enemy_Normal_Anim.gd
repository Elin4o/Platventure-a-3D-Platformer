extends Spatial

onready var anim_player =$"./AnimationPlayer"

func _process(_delta):
	anim_player.play("Armature|mixamocom|Layer0")
