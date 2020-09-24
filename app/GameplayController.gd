extends Node

export (PackedScene) onready var player_blueprint
var next_level:PackedScene = null;
var current_level:PackedScene = null;
var player = null

onready var level_container = $LevelContainer

func _ready():
	yield(get_tree(), "idle_frame")
	$AmbientAudio.play()
	player = player_blueprint.instance()
	add_child(player)
	# warning-ignore:return_value_discarded
	EventBus.connect("player_dead", self,"onPlayerDeath")
	# warning-ignore:return_value_discarded
	EventBus.connect("stage_cleared", self, "onStageCleared")
	
	if !next_level:
		next_level = load("res://app/levels/Level_debug.tscn")
	loadNextLevel()


func onPlayerDeath():
	$RestartTimer.start()

func _on_RestartTimer_timeout():
	if level_container.get_child_count():
		var current_scene = level_container.get_child(0).filename
		initLevel(load(current_scene))
		
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
	player.teleportModeOn()
	# Дадим время игроку приготовиться к телепортации
	yield(get_tree(), "idle_frame")
	player.set_position(level.getPlayerSpawnPosition())
	yield(get_tree(), "idle_frame")
	# Врагам тоже нужно перекур
	get_tree().call_group("enemies", "set_player", player)
	player.teleportModeOff()
