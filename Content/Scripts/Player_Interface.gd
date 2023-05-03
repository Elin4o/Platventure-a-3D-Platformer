extends CanvasLayer

func _process(_delta):
	$Interface/Score.text = String(GlobalSettings.score)
	

func _on_Player_collected_coin():
	$Interface/CoinCounter.text = String($"..".collected_coins)

