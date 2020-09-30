extends KinematicBody2D
class_name Player

var speed			 = 200
var strafe_speed	 = 150
var rotation_speed	 = 1.8
var max_health		 = 10
var current_health	 = max_health
var is_changing_weapon = false
var is_alive		 = true

var velocity = Vector2.ZERO
var rotation_dir = 0

onready var weapons 			= $Weapons
onready var weapon_change_timer = $WeaponChangeTimer
onready var sfx_weapon_swap 	= $SFX_WeaponSwap


func _ready():
	EventBus.emit_signal("weapon_changed",getCurrnetWeapon().getWeaponState())

func get_input():
	rotation_dir = 0
	velocity = Vector2.ZERO
	
	var cur_speed = speed
	
	if Input.is_action_pressed("player_strafe_right"):
		cur_speed = strafe_speed
		velocity += transform.y * cur_speed
	if Input.is_action_pressed("player_strafe_left"):
		cur_speed = strafe_speed
		velocity -= transform.y * cur_speed
	
	if Input.is_action_pressed("player_rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("player_rotate_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("player_backward"):
		velocity -= transform.x * cur_speed
	if Input.is_action_pressed("player_forward"):
		velocity += transform.x * cur_speed
	if Input.is_action_pressed("player_shoot"):
		self.shoot()
	if Input.is_action_just_pressed("player_reload"):
		self.reload()
	if Input.is_action_just_pressed("player_next_weapon"):
		changeCurrentWeapon()
		
func _physics_process(delta):
	if !is_alive:
		return
		
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
	
func shoot():
	var weapon = getCurrnetWeapon()
	if (weapon.has_method('shoot')):
		weapon.shoot()
	
func reload():
	var weapon = getCurrnetWeapon()
	if (weapon.has_method('reload')):
		weapon.reload()
	
func getWeaponState()->Dictionary:
	var weapon = getCurrnetWeapon()
	if (weapon.has_method('getWeaponState')):
		return weapon.getWeaponState()
	return {
		"name":"Bare hands",
		"in_clip": 1,
		"in_bandolier":1
	}

func getCurrnetWeapon():
	return weapons.get_child(0)
	
func changeCurrentWeapon():
	if (is_changing_weapon):
		return

	var weapons_pool_count = weapons.get_child_count()
	if (weapons_pool_count == 1):
		return
	
	is_changing_weapon = true
	
	var current_weapon = getCurrnetWeapon()
	current_weapon.is_avaliable = false
	current_weapon.hide()
	weapons.move_child(getCurrnetWeapon(), weapons_pool_count - 1)
	weapon_change_timer.start()
	sfx_weapon_swap.play()
	
	
func onWeaponChangeTimeout():
	var current_weapon = getCurrnetWeapon()
	current_weapon.is_avaliable = true
	is_changing_weapon = false
	current_weapon.show()
	EventBus.emit_signal("weapon_changed",current_weapon.getWeaponState())
	
func take_hit(incoming_damage):
	current_health -= int(incoming_damage)
	
	if current_health <= 0:
		is_alive = false
		$Collider.set_deferred("disabled", true)
		$Direction.hide()
		$Body.stop()
		EventBus.emit_signal("player_dead")

func teleportModeOn():
	$Camera.smoothing_enabled = false

func teleportModeOff():
	$Camera.smoothing_enabled = true
	resurect()
	
func resurect():
	is_alive = true
	$Collider.set_deferred("disabled", false)
	$Direction.show()
	$Body.play()
	if (current_health <= 0):
		current_health = max_health

func getWeapons():
	return weapons
	
func saveState(save_data: Dictionary):
	save_data["player"] = {
		"current_health" : self.current_health
	}

func loadState(load_data:Dictionary):
	print('Player load init')
	current_health = load_data['player']['current_health']
	yield(get_tree(),"idle_frame")
	resurect()
	EventBus.emit_signal("weapon_changed",getCurrnetWeapon().getWeaponState())
	
