extends Spatial

signal level_changed(level_name)

export (String) var level_name = "level"


func _on_AreaSceneSwticher_body_entered(body):
		if body.is_in_group("Player"):
			emit_signal("level_changed",level_name)


