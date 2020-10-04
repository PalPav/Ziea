extends Area2D
class_name AbstractItem

onready var sfx_pickup = $SFX_PickUp
onready var pickup_range = $PickUpRange
onready var player_detector_ray = $PlayerDetectionRay

var detection_radius = 500


func _ready():
	$Icon.hide()
	detectPlayer()

func detectPlayer():
	if !EM.getPlayer():
		return
		
	var enemy_to_player = EM.getPlayer().position - self.position
	if enemy_to_player.length() > detection_radius:
		return
		
	player_detector_ray.set_deferred('cast_to', enemy_to_player)
	
	if !player_detector_ray.is_colliding():
		return

	if !player_detector_ray.get_collider() || player_detector_ray.get_collider().get_name() != 'Player': 
		return
	$Icon.show()
	$PickUpRange.set_deferred("disabled", false)
	$PlayerDetectionTimer.queue_free()
	player_detector_ray.queue_free()

func onPickupRangeBodyEntered(body):
	if !(body is Player):
		return
		
	if !body.is_alive:
		return
		
	if handlePckup(body):
		sfx_pickup.play()
		pickup_range.set_deferred("disabled", true)
		self.hide()

func handlePckup(_player: Player)->bool:
	return false
	
func _on_PlayerDetectionTimer_timeout():
	detectPlayer()
