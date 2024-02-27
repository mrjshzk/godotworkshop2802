extends RigidBody2D
class_name Bullet

@export var bullet_speed := 2000.0

func spawn(spawn_position: Vector2, direction : Vector2, bullet_rotation: float):
	rotation = bullet_rotation
	self.global_position = spawn_position
	apply_impulse(direction * bullet_speed)
	$Timer.start()


func _on_timer_timeout():
	queue_free()
