extends KinematicBody2D

var is_alive = true
var is_player_detected = false
var player = null
var velocity = Vector2.ZERO

export var speed = 150
export var damage = 10
export var detection_radius = 500
export var health = 25

onready var death_sound = $SFX_Death
onready var hit_sound = $SFX_Hit
onready var detect_sound = $SFX_Detect
onready var player_detector_ray = $PlayerDetectorRay
onready var hit_effect = $HitEffect

func _ready():
	$HitEffect.show()
	yield(get_tree(), "idle_frame")
	EventBus.emit_signal("enemy_spawned")

func take_hit(incoming_damage:int, global_hit_pos:Vector2):
	self.health -= int(incoming_damage)
	if self.health <= 0:
		return self.die()
	hit_effect.position = to_local(global_hit_pos)
	hit_effect.emitting = true
	hit_sound.play()
	
func set_player(player_ref):
	player = player_ref
 
func _physics_process(_delta):
	chase_player()
	
func _on_PlayerDetectionTimer_timeout():
	detect_player()
		
func chase_player():
	if !is_player_detected || !is_alive || !player:
		return
	# Пока противники максимально тупые )))
	velocity = position.direction_to(player.position) * speed
	velocity = move_and_slide(velocity)
	
func detect_player():
	if is_player_detected || !is_alive || !self.player:
		return

	var enemy_to_player = player.position - self.position
	
	if enemy_to_player.length() > detection_radius:
		return
		
	player_detector_ray.set_deferred('cast_to', enemy_to_player)
	
	if !player_detector_ray.is_colliding():
		return

	if !player_detector_ray.get_collider() || player_detector_ray.get_collider().get_name() != 'Player': 
		return
		
	is_player_detected = true
	$Alive.set_deferred("visible", true)
	detect_sound.play()
	$Collider.set_deferred("disabled", false)
	$PlayerDetectionTimer.queue_free()
	player_detector_ray.queue_free()
	
func die():
	if !self.is_alive:
		return
	
	self.is_alive = false
	death_sound.play()
	$Alive.hide()
	$Dead.show()
	$Collider.set_deferred("disabled", true)
	$AttackZone/AttackZoneShape.disabled = true
	# Трупы выше живых для того чтобы не перекрывали их при наложении
	get_parent().move_child(self, 0)
	EventBus.emit_signal("enemy_died")
	
func _on_AttackZone_body_entered(body):
	if body.get_name() == 'Player' && body.has_method('take_hit'):
		print('ENEMY ATTACK', name)
		body.take_hit(self.damage)
		
