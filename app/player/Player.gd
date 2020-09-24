extends KinematicBody2D

var speed = 200
var strafe_speed = 150
var rotation_speed = 1.8
var damage = 10
var max_health = 10
var current_health = max_health
var is_shooting_available = true
var is_reloading = false
var is_alive = true

var velocity = Vector2.ZERO
var rotation_dir = 0

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
	if Input.is_action_pressed("player_reload"):
		self.reload()
	
func _physics_process(delta):
	if !is_alive:
		return
		
	get_input()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)
	
func shoot():
	$Weapons/Pistol.shoot()
	
func reload():
	$Weapons/Pistol.reload()

func _on_GunTimer_timeout():
	self.is_shooting_available = true
	
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
	current_health = max_health
