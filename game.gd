extends Node2D

func _ready():
	get_tree().paused = false

func _on_player_player_died():
	get_tree().paused = true
	$CanvasLayer.show()


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed():
	get_tree().quit()

