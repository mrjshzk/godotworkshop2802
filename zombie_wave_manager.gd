extends Node2D

@export var spawn_points : Array[Marker2D]
var zombie_scene := preload("res://zombie.tscn")

var current_wave := 1
@export var zombies_to_spawn : int = 3
@export var spawn_multiplier := 1.35
var zombies_left : int

signal wave_changed(wave_number)

func _process(delta):
	$WaveUI/PanelContainer/VBoxContainer/CurrentWave.text = "Current Wave: %d" % current_wave
	$WaveUI/PanelContainer/VBoxContainer/ZombiesLeft.text = "Zombies Left: %d" % zombies_left

func _ready():
	start_new_wave()

func start_new_wave():
	zombies_left = zombies_to_spawn
	var number_of_loops := zombies_to_spawn / spawn_points.size()
	var overload_loops := (zombies_to_spawn - (number_of_loops * spawn_points.size()))

	for j in range(0, number_of_loops):
		for i in spawn_points:
			spawn_zombie(i.global_position)
			await get_tree().create_timer(0.2).timeout
	
	for i in range(0, overload_loops):
		spawn_zombie(spawn_points[i].global_position)
		await get_tree().create_timer(0.2).timeout


func spawn_zombie(spawn_point : Vector2):
	var new_zombie : Zombie = zombie_scene.instantiate()
	new_zombie.global_position = spawn_point
	new_zombie.died.connect(zombie_died)
	call_deferred("add_child", new_zombie)
	await get_tree().process_frame

func zombie_died():
	zombies_left -= 1
	if zombies_left == 0:
		zombies_to_spawn = int(zombies_to_spawn * spawn_multiplier)
		print(zombies_to_spawn)
		current_wave += 1
		start_new_wave()
