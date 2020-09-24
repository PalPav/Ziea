extends Node2D
class_name AbstractWeapon

var clip_size:int = 12
var bandolier_size:int = 60
var clip_ammo_amount:int = 12
var bandolier_ammo_amount:int = 24
var damage:int = 10

var is_ammo_ready = true
var is_rof_lock = true
var is_avaliable = false

onready var sfx_reload = $SFX_Reload
onready var sfx_shot = $SFX_Shot
onready var sfx_empty_clip = $SFX_EmptyClip
onready var timer_reload = $Timer_Reload
onready var timer_rof = $Timer_ROF

func onReloadFinish():
	is_ammo_ready = true
	EventBus.emit_signal("weapon_reloaded", getWeaponState())
	
func onRofUnlock():
	is_rof_lock = false

func canShoot()->bool:
	return is_avaliable && is_ammo_ready && !is_rof_lock && clip_ammo_amount > 0
	
func shoot():
	if !canShoot():
		return
		
	if shootLogic():
		clip_ammo_amount -= 1
		is_rof_lock = true
		self.sfx_shot.play()
		EventBus.emit_signal("shot_fired", getWeaponState())
		timer_rof.start()
	
	
func reload():
	
	if is_ammo_ready && reloadLogic():
		is_ammo_ready = false
		sfx_reload.play()
		timer_reload.start()

# переопределить логику стрельбы
func shootLogic():
	pass

# переопределить логику перезарядки
func reloadLogic():
	pass

func getWeaponState():
	return {
		'name':self.name,
		'in_clip': clip_ammo_amount,
		'in_bandolier':bandolier_ammo_amount
	}
