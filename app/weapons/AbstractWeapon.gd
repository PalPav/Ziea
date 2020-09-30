extends Node2D
class_name AbstractWeapon

const SAVE_PREFIX = "weapon_"

var clip_size:int = 12
var bandolier_size:int = 60
var clip_ammo_amount:int = 12
var bandolier_ammo_amount:int = 24
var damage:int = 10

var is_ammo_ready = true
var is_rof_lock = true
var is_avaliable = false
var has_empty_clip_sound = true
var is_empty_clip_sound_available = true

onready var sfx_reload = $SFX_Reload
onready var sfx_shot = $SFX_Shot
onready var sfx_empty_clip = $SFX_EmptyClip
onready var timer_reload = $Timer_Reload
onready var timer_rof = $Timer_ROF

func onReloadFinish():
	is_ammo_ready = true
	is_empty_clip_sound_available = true
	EventBus.emit_signal("weapon_reloaded", getWeaponState())
	
func onRofUnlock():
	is_rof_lock = false

func canShoot()->bool:
	return is_avaliable && is_ammo_ready && !is_rof_lock && clip_ammo_amount > 0
	
func canPlayEmptyClipReloadSound()->bool:
	return has_empty_clip_sound && clip_ammo_amount <= 0 && is_empty_clip_sound_available && !is_rof_lock
	
func shoot():
	if !canShoot():
		if (canPlayEmptyClipReloadSound()):
			is_empty_clip_sound_available = false
			sfx_empty_clip.play()
		return
		
	if shootLogic():
		clip_ammo_amount -= 1
		is_rof_lock = true
		self.sfx_shot.play()
		EventBus.emit_signal("shot_fired", getWeaponState())
		timer_rof.start()
	
	
func reload():
	if is_avaliable && is_ammo_ready && reloadLogic():
		is_ammo_ready = false
		sfx_reload.play()
		timer_reload.start()

# переопределить логику стрельбы
func shootLogic():
	pass

# переопределить логику перезарядки
func reloadLogic():
	pass

func getWeaponState()->Dictionary:
	return {
		'name':self.name,
		'in_clip': clip_ammo_amount,
		'in_bandolier':bandolier_ammo_amount
	}

func saveState(save_data: Dictionary):
	save_data[str(SAVE_PREFIX, name)] = getWeaponState()
	
func loadState(load_data: Dictionary):
	print('W load init')
	var weapon_save_key = str(SAVE_PREFIX, name)
	clip_ammo_amount = load_data[weapon_save_key]["in_clip"]
	bandolier_ammo_amount = load_data[weapon_save_key]["in_bandolier"]
