extends KinematicBody

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
		body._velocity.y = 15
		body._snap_vector = Vector3.ZERO
		body.move_and_slide_with_snap(body._velocity,body._snap_vector)

