extends Control

@onready var icon_rect = $LeftPanel/ArtifactIcon
@onready var name_label = $LeftPanel/NameLabel
@onready var desc_label = $RightPanel/DescriptionLabel

var current_index = 0
var relic_list = []

func _ready():
	relic_list = DataManager.relic_db.duplicate()
	relic_list.sort_custom(func(a, b): return a["id"] < b["id"])
	
	if relic_list.size() > 0:
		update_display()

func update_display():
	if relic_list.is_empty(): return
	var relic = relic_list[current_index]
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.text = relic["description"]
	
	if ResourceLoader.exists(relic["image_path"]):
		icon_rect.texture = load(relic["image_path"])
	
	name_label.text = relic["name"]
	desc_label.text = relic["description"]

func _on_nav_button_back_pressed():
	current_index -= 1
	if current_index < 0: current_index = relic_list.size() - 1
	update_display()

func _on_nav_button_next_pressed():
	current_index += 1
	if current_index >= relic_list.size(): current_index = 0
	update_display()

func _on_lobby_button_pressed():
	get_tree().change_scene_to_file("res://main_lobby.tscn")
