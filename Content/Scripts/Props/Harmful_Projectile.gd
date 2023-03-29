extends Area

var dir = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready()-> void:
	set_as_toplevel(true)
	$ProjectileTimer.start()


func _process(delta: float)-> void:
	translation -= transform.basis.x * 15 * delta

func _on_Harmful_Projectile_body_entered(body):
	if body.is_in_group("Player"):
		body.health.current -= 1

	queue_free()

func _on_ProjectileTimer_timeout():
	queue_free()
