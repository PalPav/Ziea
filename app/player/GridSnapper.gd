extends Position2D

var grid_size = Vector2(640, 480)
var grid_position = Vector2()

onready var player = get_parent()

func _ready():
	self.set_as_toplevel(true)
	self.update_grid_position()
	
func _physics_process(_delta):
	update_grid_position()

func update_grid_position():
	var x = round(player.position.x / grid_size.x)
	var y = round(player.position.y / grid_size.y)
	var new_grid_position = Vector2(x, y)
	
	if self.grid_position == new_grid_position:
		return
	
	self.grid_position = new_grid_position
	self.position = grid_position * grid_size
