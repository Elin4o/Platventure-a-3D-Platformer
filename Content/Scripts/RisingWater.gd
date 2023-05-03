extends Area

var can_rise = false

func _physics_process(_delta):
	if can_rise == true:
		start_rising()
	

func _on_RisingWater_body_entered(body):
	if body.is_in_group("Player"):
		can_rise = true

func start_rising():
	can_rise = false
	$Timer.start()
	$KillArea.translation.y += 0.5
	
	if $KillArea.translation >= Vector3(0,35,0):
		can_rise = false
		$Timer.stop()
		return
	


func _on_Timer_timeout():
	can_rise = true


func _on_KillArea_body_entered(body):
	if body.is_in_group("Player"):
		can_rise = false
		$Timer.stop()
		$KillArea.translation = Vector3(0,-22,0)
