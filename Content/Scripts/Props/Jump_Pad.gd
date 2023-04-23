extends Spatial

export var launch_height := 10
onready var anim_player = get_node("AnimationPlayer")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body._velocity.y = launch_height
		body._anim_tree["parameters/playback"].travel("Jumping")
		body._snap_vector = Vector3.ZERO
		body.move_and_slide_with_snap(body._velocity,body._snap_vector)
		anim_player.play("Spring_Movement")
		$Spring.play()
