extends Node

var is_loading = false
const SAVE_GAME_PATH = "user:///zeia_save.save"

func runNewGame():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://app/GameplayController.tscn")

func continueGame():
	is_loading = true
	runNewGame()
	
func _ready():
	# warning-ignore:return_value_discarded
	EventBus.connect("level_ready", self, "saveGame")

#func _input(event):
	#if event.is_action_pressed("save_game"):
		#saveGame()
	#if event.is_action_pressed("load_game"):
		#loadGame()

func isSaveFileExists()->bool:
	var save_game = File.new()
	return save_game.file_exists(SAVE_GAME_PATH)

func saveGame():
	var save_data = {}
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("saveState"):
			print("persistent node '%s' is missing a saveState() function, skipped" % node.name)
			continue

		# Call the node's save function.
		node.call("saveState", save_data)

	save_data = to_json(save_data)
	var save_game = File.new()
	save_game.open(SAVE_GAME_PATH, File.WRITE)
	save_game.store_line(save_data)
	save_game.close()
	
func loadGame():	
	var save_game = File.new()
	if not save_game.file_exists(SAVE_GAME_PATH):
		return # Error! We don't have a save to load.

	save_game.open(SAVE_GAME_PATH, File.READ)
	var load_data = parse_json(save_game.get_line())
	
	var load_nodes = get_tree().get_nodes_in_group("persist")
	for node in load_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("loadState"):
			print("persistent node '%s' is missing a loadState() function, skipped" % node.name)
			continue
			
		node.loadState(load_data)

	save_game.close()

func showCredits():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://app/credits/Credits.tscn")
