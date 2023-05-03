extends Spatial

export var bullet : PackedScene

var can_shoot : bool = true

func _physics_process(_delta):
	if can_shoot:
		shoot()
		
func shoot():
	can_shoot = false
	
	$ShootTimer.start()
	
	var b = bullet.instance()
	
	$BulletPoint.add_child(b)

func _on_ShootTimer_timeout():
	can_shoot = true
	$Shoot.play()
	$Particles.emitting = true
