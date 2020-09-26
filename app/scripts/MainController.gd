extends Node


func runNewGame():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://app/GameplayController.tscn")
