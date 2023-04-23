extends CanvasLayer

func _on_Player_collected_coin():
	$Interface/CoinCounter.text = String($"..".collected_coins)
