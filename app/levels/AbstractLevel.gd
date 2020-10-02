extends Node
class_name AbstractLevel

const DOOR_TILE_HORIZONTAL_ID = 6
const DOOR_TILE_VERTICAL_ID  = 7
const PLAYER_SPAWN_TILE_ID = 8
const LEVEL_EXIT_TILE_ID = 9
const TILE_SIZE = 100
const PLAYERS_GROUP = 'players'

export (PackedScene) var door_blueprint
export (PackedScene) var next_level

onready var level_map = $Map
onready var level_exit = $Exit

var is_stage_clear = false

func _ready():
	if !door_blueprint:
		door_blueprint = load("res://app/door/Door.tscn")
	initActiveZones()
	if $Enemies.get_child_count() > 0:
		# warning-ignore:return_value_discarded
		EventBus.connect("enemy_died", self,"onEnemyDeath")
# warning-ignore:return_value_discarded
	else:
		activateExit()
	yield(get_tree(),"idle_frame")
	EventBus.emit_signal("level_ready")
func initActiveZones()->void:
	spawnDoors()
	
	setLevelExit()
func setLevelExit()->void:
	var points = level_map.get_used_cells_by_id(LEVEL_EXIT_TILE_ID)
	if points.size():
		level_exit.set_position(getPositionFromTile(points.front()))
	else:
		push_error('Level have no exit tile')
func spawnDoors()->void:
	for door_coorinates in level_map.get_used_cells_by_id(DOOR_TILE_HORIZONTAL_ID):
		spawnDoor(door_coorinates)
	for door_coorinates in  level_map.get_used_cells_by_id(DOOR_TILE_VERTICAL_ID):
		spawnDoor(door_coorinates, true)

func spawnDoor(tile_coords, is_vertical = false)->void:
		var door = door_blueprint.instance()
		door.set_position(getPositionFromTile(tile_coords))
		if is_vertical:
			door.set_deferred('rotation_degrees', 90)
		self.add_child(door)

func getPlayerSpawnPosition()->Vector2:	
	var points = level_map.get_used_cells_by_id(PLAYER_SPAWN_TILE_ID)
	if points.size():
		return getPositionFromTile(points.front())
	else:
		push_error('Level have no player spawn tile')
	return(Vector2(0,0))
func activateExit():
	yield(get_tree().create_timer(1),"timeout")
	is_stage_clear = true
	$SFX_StageClear.play()
	$Exit/Animation.play("welcome")	

func onEnemyDeath():
	
	if $Enemies.getAliveCount() < 1:
		activateExit()
		
func _on_Exit_body_entered(body):
	if (is_stage_clear && body.is_in_group(PLAYERS_GROUP)):
		EventBus.emit_signal("stage_cleared")

func getNextLevel():
	return next_level

func getPositionFromTile(tile_coords:Vector2)->Vector2:
	return Vector2(# warning-ignore:integer_division
		tile_coords.x * TILE_SIZE + TILE_SIZE/2,# warning-ignore:integer_division
		tile_coords.y * TILE_SIZE + TILE_SIZE/2
	)
