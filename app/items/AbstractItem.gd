extends Area2D
class_name AbstractItem

var weapon_name = "Shotgun"
var ammo_count = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func onPickupRangeBodyEntered(player):
	if (player.name != "Player" || !player.has_method("getWeapons")):
		return
	var weapon = player.getWeapons().get_node(weapon_name)
	
	if !weapon:
		return
	
	weapon.bandolier_ammo_amount += 4
	EventBus.emit_signal("weapon_changed", player.getCurrnetWeapon().getWeaponState())
	$PickUpRange.set_deferred("disabled", true)
	self.hide()
