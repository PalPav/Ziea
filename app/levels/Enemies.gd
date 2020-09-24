extends Node

onready var enemies = self.get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getAliveCount():
	var alive_count = 0;
	for enemy in enemies:
		if (enemy.is_alive):
			alive_count += 1
	return alive_count
