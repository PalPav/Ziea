extends AbstractGear

var scan_range = 600
onready var timer_scan = $Timer_Scan	
	

func scanArea():
	if (!EM.getPlayer()):
		return
		
	var enemies = get_tree().get_nodes_in_group('enemies')
	
	for enemy in enemies:
		if !enemy.is_alive:
			continue
		if enemy.is_player_detected:
			continue
		
		var distance = enemy.position.distance_to(EM.getPlayer().position)
		
		# Возможно стоит включать врагам коллайдер когда они подсвечены
		# для того чтобы можно было стрелять во врага который тебя не видит например из за угла
		# но в случае попадания враг будет автоматически обнаруживать игрока (если будет жив)
		if distance < scan_range:
			enemy.showAlive()
		else:
			enemy.hideAlive()
		

func enable():
	timer_scan.start()
	
func disable():
	timer_scan.stop()
	
	var enemies = get_tree().get_nodes_in_group('enemies')
	for enemy in enemies:
		if enemy.is_alive && !enemy.is_player_detected:
			enemy.hideAlive()
		
