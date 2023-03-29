extends PathFollow

export var runSpeed = 5

func _process(delta):
	set_offset(get_offset() + runSpeed * delta)
