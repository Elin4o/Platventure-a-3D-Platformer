extends Spatial

export var ammount_to_open = 10



func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.collected_coins >= ammount_to_open:
			queue_free()
		else:
			var left_ammount = ammount_to_open - body.collected_coins
			$Label3D.text = ( "You need " +  String(left_ammount) + " more coins to open")
