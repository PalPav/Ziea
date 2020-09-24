extends MarginContainer

var enemies_count:int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	EventBus.connect("enemy_spawned", self,"onEnemySpawned")
	# warning-ignore:return_value_discarded
	EventBus.connect("enemy_died", self,"onEnemyDied")
	resetEnemiesCount()

func resetEnemiesCount():
	enemies_count = 0
func onEnemySpawned():
	enemies_count += 1
	self.redrawEnemiesCount()
func onEnemyDied():
	enemies_count -= 1
	self.redrawEnemiesCount()
	
func redrawEnemiesCount():
	$HBoxContainer/EnemiesCounter/Label.text = str(enemies_count)
