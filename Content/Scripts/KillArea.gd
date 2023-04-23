extends Area


func _on_KillArea_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt_Sound()
		body.kill()
