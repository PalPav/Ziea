extends MarginContainer


func _on_New_game_pressed():
	MainController.runNewGame()


func _on_Exit_pressed():
	get_tree().quit()


func _on_Continue_pressed():
	pass # Replace with function body.
