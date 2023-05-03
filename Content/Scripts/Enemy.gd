extends KinematicBody

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		$Death.emitting = true
		$Destroyed.play()
		body._velocity.y = 15
		body._snap_vector = Vector3.ZERO
		body.move_and_slide_with_snap(body._velocity,body._snap_vector)



func _on_Destroyed_finished():
		GlobalSettings.score += 200
		
		queue_free()
