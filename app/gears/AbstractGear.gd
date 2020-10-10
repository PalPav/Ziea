extends Node2D
class_name AbstractGear

onready var timer_battery = $Timer_Battery
onready var sfx_enabled = $SFX_Enabled
onready var sfx_disabled = $SFX_Disabled

var is_enabled = false
var full_charge_time = 100

func onBatteryDischarged():
	sfx_disabled.play()
	is_enabled = false
	disableGear()

func disableGear():
	pass
	
func enableGear():
	pass

func addCharge(charge_amount):
	timer_battery.wait_time = charge_amount
	
	if !is_enabled:
		timer_battery.start()
		enableGear()
