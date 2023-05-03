extends Node

onready var prop = $RotatingObstacle


func _ready():
	prop.visible = false

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		if body.collected_coins >= 10:
			prop.visible = true
