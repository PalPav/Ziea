extends Area2D
class_name AbstractItem

onready var sfx_pickup = $SFX_PickUp
onready var pickup_range = $PickUpRange

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onPickupRangeBodyEntered(player):
	if !(player is Player):
		print('DET', player is Player)
		return
		
	if handlePckup(player):
		sfx_pickup.play()
		pickup_range.set_deferred("disabled", true)
		self.hide()

func handlePckup(_player: Player)->bool:
	return false
