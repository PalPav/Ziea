extends Area2D

onready var door_animator = $DoorAnimation
onready var door_sound = $DoorSound

func isDoorLocked(body)->bool:
	var visiors_count = getKinemacticBodiesCount(self.get_overlapping_bodies())
	if visiors_count > 1:
		return true
	if not (body is KinematicBody2D):
		return true
	return false

func getKinemacticBodiesCount(bodies)->int:
	var count = 0
	for body in bodies:
		if body is KinematicBody2D:
			count += 1
	return count


func _on_Door_body_entered(body)->void:
	if isDoorLocked(body):
		return
	door_animator.play("FlapOpen")
	door_sound.play()


func _on_Door_body_exited(body)->void:
	if isDoorLocked(body):
		return
	door_animator.play_backwards("FlapOpen")
	door_sound.play()
