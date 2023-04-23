extends Spatial

onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("Rotating")

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		body.collected_coins += 1
		body.emit_signal("collected_coin")
		anim_player.play("Collected")
		$Collected.play()

func _on_Collected_finished():
	queue_free()
