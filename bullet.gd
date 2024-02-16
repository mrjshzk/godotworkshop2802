extends RigidBody2D
class_name Bullet

@export var bullet_speed := 10_000_000.0

func spawn(spawn_position: Vector2, direction : Vector2, bullet_rotation: float):
	rotation = bullet_rotation
	self.global_position = spawn_position
	apply_force(direction * bullet_speed * get_process_delta_time())
	$Timer.start()


func _on_timer_timeout():
	queue_free()
