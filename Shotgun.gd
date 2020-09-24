extends AbstractWeapon

func _init():
	clip_size = 2
	bandolier_size = 20
	clip_ammo_amount = 2
	bandolier_ammo_amount = 20
	damage = 6
	is_ammo_ready = true
	is_avaliable = true

onready var los = $LoS

func _ready():
	timer_rof.wait_time = 0.5
	timer_reload.wait_time = 1.5
	is_rof_lock = false
	
func shootLogic():
	for pellet in los.get_children():
		var target = pellet.get_collider()
		if pellet.is_colliding() and target.has_method("take_hit"):
			target.take_hit(damage, pellet.get_collision_point())
			yield(get_tree(), "idle_frame")
	
	return true

func reloadLogic():
	if (clip_ammo_amount >= clip_size):
		return false
		
	if (bandolier_ammo_amount <= 0):
		bandolier_ammo_amount = 24
		return false
		
	
	var need_to_load_count =  clip_size - clip_ammo_amount;
	
	if (bandolier_ammo_amount <= need_to_load_count):
		clip_ammo_amount += bandolier_ammo_amount
		bandolier_ammo_amount = 0
		return true
		
	if (bandolier_ammo_amount > need_to_load_count):
		clip_ammo_amount += need_to_load_count
		bandolier_ammo_amount -=need_to_load_count
	
	return true
