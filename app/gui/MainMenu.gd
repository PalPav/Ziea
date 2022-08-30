extends MarginContainer

func _ready():
	if MainController.isSaveFileExists():
		enableContinue()

func _on_New_game_pressed():
	MainController.runNewGame()


func _on_Exit_pressed():
	get_tree().quit()
	
func _on_Continue_pressed():
	MainController.continueGame()
	
func enableContinue():
	$HBoxContainer/VBoxContainer/Options/Continue.set_deferred("disabled", false)


func _on_Credits_pressed():
	MainController.showCredits()
	pass # Replace with function body.
