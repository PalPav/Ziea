extends AbstractItem
class_name GearItem

var gear_name = ''
var seconds_to_add = 30

func handlePckup(player)->bool:
	var gear = player.getGears().get_node(gear_name)
	if !gear:
		return false
	gear.addCharge(seconds_to_add)
	
	return true
