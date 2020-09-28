extends AbstractItem
class_name AmmoItem

var weapon_name = ""
var	ammo_count = 0

func handlePckup(player)->bool:
	var weapon = player.getWeapons().get_node(weapon_name)
	if !weapon:
		return false
	
	var bandolier_free_space = weapon.bandolier_size - weapon.bandolier_ammo_amount
	
	if (bandolier_free_space <= 0):
		return false
	
	if (bandolier_free_space < ammo_count):
		weapon.bandolier_ammo_amount = weapon.bandolier_size
	
	if (bandolier_free_space >= ammo_count):
		weapon.bandolier_ammo_amount += ammo_count
	
	EventBus.emit_signal("weapon_changed", player.getCurrnetWeapon().getWeaponState())
	
	return true
