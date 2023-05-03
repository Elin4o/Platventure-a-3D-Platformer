extends Node


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.collected_coins = 0
		body.emit_signal("collected_coin")
		
	queue_free()
