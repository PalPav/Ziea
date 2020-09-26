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
	# warning-ignore:return_value_discarded
	EventBus.connect("shot_fired", self, "setWeaponState")
	# warning-ignore:return_value_discarded
	EventBus.connect("weapon_reloaded", self, "setWeaponState")
	# warning-ignore:return_value_discarded
	EventBus.connect("weapon_changed", self, "setWeaponState")
		
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
	
func setWeaponState(weapon:Dictionary):
	$HBoxContainer/WeaponName/Label.text = str(weapon.name)
	$HBoxContainer/AmmoCount/Label.text = str(weapon.in_clip, " / ", weapon.in_bandolier)
