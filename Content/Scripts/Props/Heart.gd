extends Area


export var heal_ammount := 1

func _on_Heart_body_entered(body):
	if body.is_in_group("Player"):
		print("Entered")
		body.health.current += heal_ammount

