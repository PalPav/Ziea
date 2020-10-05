extends Node

export (PackedScene) onready var player_blueprint
var next_level:PackedScene = null;
var current_level:PackedScene = null;

onready var level_container = $LevelContainer

func _ready():
	yield(get_tree(), "idle_frame")
	$AmbientAudio.play()
	EM.setPlayer(player_blueprint.instance())
	add_child(EM.getPlayer())
	# warning-ignore:return_value_discarded
	EventBus.connect("player_dead", self,"onPlayerDeath")
	# warning-ignore:return_value_discarded
	EventBus.connect("stage_cleared", self, "onStageCleared")
	
	if (MainController.is_loading):
		MainController.loadGame()
		return
		
	if !next_level:
		next_level = load("res://app/levels/Level_001.tscn")
	loadNextLevel()
	
func onPlayerDeath():
	$RestartTimer.start()

func _on_RestartTimer_timeout():
	MainController.loadGame()
		
func onStageCleared():
	$TeleportTimer.start()
		
func loadNextLevel():
	if !next_level:
		return
	initLevel(next_level)
	
func initLevel(level_scene:PackedScene):
	if level_container.get_child_count():
		level_container.get_child(0).queue_free()
		yield(get_tree(), "idle_frame")
	
	$GuiLayer/GameplayUI.resetEnemiesCount()
	
	var level = level_scene.instance()
	# Добавляем уровень в дерево в самом начале чтобы у него сработал _on_ready
	# и заполнились onready var  
	level_container.call_deferred("add_child",level)
	next_level = level.getNextLevel()
	EM.getPlayer().teleportModeOn()
	# Дадим время игроку приготовиться к телепортации
	yield(get_tree(), "idle_frame")
	EM.getPlayer().set_position(level.getPlayerSpawnPosition())
	yield(get_tree(), "idle_frame")
	EM.getPlayer().teleportModeOff()

func saveState(save_data):
	save_data["gameplay_contoller"] = {
		"current_level" : getCurrentLevel().get_filename()
	}

func loadState(save_data):
	var load_level = load(save_data["gameplay_contoller"]["current_level"]);
	initLevel(load_level)

func getCurrentLevel():
	return level_container.get_child(0);
