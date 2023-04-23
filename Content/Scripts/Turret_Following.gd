extends Spatial

enum {
	IDLE,
	ALERT
}

var state = IDLE

onready var raycast = $Raycast_Follow
onready var eyes = $Eyes

var target 

export var TURN_SPEED = 2

func _ready():
	pass # Replace with function body.


func _on_SightRange_body_entered(body):
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		var shooting = get_node("StationaryTurret/ShootTimer")			
		shooting.start()



func _on_SightRange_body_exited(body):
	state = IDLE

func _process(delta):
	match state:
		IDLE:
			var shooting = get_node("StationaryTurret")
			shooting.can_shoot = false
		ALERT:
			eyes.look_at(target.global_transform.origin,Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))			
		
