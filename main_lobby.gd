extends Node2D

func _ready():
	pass 

# 1번 문
func _on_door_1_body_entered(body: Node2D):
	
	if body.name == "Player" or body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", "res://game_1_match.tscn")

# 2번 문
func _on_door_2_body_entered(body: Node2D):
	
	if body.name == "Player" or body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", "res://game_2_memory.tscn")
		
# 3번 문
func _on_door_3_body_entered(body: Node2D):
	
	if body.name == "Player" or body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", "res://game_3_halli.tscn")
		
func _on_gallery_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://relic_gallery.tscn")
