extends Area

export var damage_ammount := 1

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		print("Entered")
		body.health.current -= damage_ammount
