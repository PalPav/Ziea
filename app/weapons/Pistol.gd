extends AbstractWeapon

func _init():
	clip_size = 12
	bandolier_size = 60
	clip_ammo_amount = 12
	bandolier_ammo_amount = 24
	damage = 10
	is_ammo_ready = true
	is_avaliable = true

onready var los = $LoS

func _ready():
	timer_rof.wait_time = 0.4
	timer_reload.wait_time = 1.5
	is_rof_lock = false
	
func shootLogic():
	var target = los.get_collider()
	if los.is_colliding() and target.has_method("take_hit"):
		target.take_hit(damage, los.get_collision_point())
	
	return true

func reloadLogic():
	if (bandolier_ammo_amount <= 0):
		bandolier_ammo_amount = 24
		return false
	elif (bandolier_ammo_amount >= clip_size):
		clip_ammo_amount = clip_size
		bandolier_ammo_amount -= clip_size
	else:
		clip_ammo_amount = bandolier_ammo_amount
		bandolier_ammo_amount = 0
	return true
