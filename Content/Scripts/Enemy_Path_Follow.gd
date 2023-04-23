extends PathFollow
onready var animation_tree = $Enemy/Enemy_Normal/AnimationPlayer
export var runSpeed = 5

func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
	
