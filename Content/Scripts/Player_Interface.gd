extends CanvasLayer

func _process(_delta):
	$Interface/CollectableScore/Score.text = String(GlobalSettings.score)
	$Interface/Time.text = GlobalSettings.time_passed
	

func _on_Player_collected_coin():
	$Interface/CollectableScore/CoinCounter.text = String($"..".collected_coins)

