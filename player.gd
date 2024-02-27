extends CharacterBody2D
class_name Player

var bullet_scene := preload("res://bullet.tscn")

signal player_died()
signal health_changed(new_health : float)

@export var player_speed := 25000.0
@export var health := 5

func _ready():
	%ProgressBar.max_value = health
	%ProgressBar.value = health

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var bullet : Bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.spawn(%BulletPosition.global_position, (%BulletPosition.global_position - global_position).normalized(), rotation)
		
	
	var horizontal_input : float = Input.get_axis("move_left", "move_right")
	var vertical_input : float = Input.get_axis("move_up", "move_down")
	
	
	velocity.x = horizontal_input * delta * player_speed
	velocity.y = vertical_input * delta * player_speed
	
	look_at(get_viewport().get_mouse_position())
	move_and_slide()

func take_damage():
	var t := create_tween()
	t.finished.connect(func(): $Blood.frame = 0)
	t.tween_property($Blood, "frame", 15, 0.5)
	health -= 1
	print("Current health: %d" % health)
	%ProgressBar.value = health
	health_changed.emit(health)
	if health == 0:
		player_died.emit()
		return
	
