extends CharacterBody2D
class_name Zombie

@export var speed := 10000.0

@export var health := 3
@export var knockback_strength := 50

@onready var player : Player = get_tree().get_first_node_in_group("Player")

var can_attack := true
signal died()

func _process(delta):
	
	if $HitBox.overlaps_body(player) and can_attack:
		player.take_damage()
		can_attack = false
		$Timer.start()
	
	look_at(player.global_position)
	velocity = (player.global_position - global_position).normalized() * speed * delta
	
	move_and_slide()


func _on_hurtbox_body_entered(body):
	if body is Bullet:
		var t := create_tween()
		#var knockback_vector : Vector2 = (global_position - $KnockbackHelper.global_position).normalized() * knockback_strength
		var knockback_vector = -velocity.normalized() * knockback_strength
		
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_CUBIC)
		
		t.tween_property(self, "global_position", global_position+knockback_vector, 0.2)
		$AnimationPlayer.play("Hit")
		health -= 1
		body.queue_free() # destroy the buller
	if health == 0:
		$Blood.scale *= 2
		died.emit()
		$Body.hide()
		$Head.hide()
		await $AnimationPlayer.animation_finished
		queue_free()

func _draw():
	draw_line(global_position, velocity.normalized(), Color.BLACK)


func _on_timer_timeout():
	can_attack = true



