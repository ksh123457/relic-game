extends Control

@onready var q_card = $QuestionCard
@onready var q_label = $QuestionLabel  
@onready var choice_container = $ChoiceContainer
@onready var feedback_label = $FeedbackLabel 
@onready var result_overlay = $ResultOverlay
@onready var score_label = $ResultOverlay/ScoreLabel
@onready var star_label = $ResultOverlay/StarLabel
@onready var start_overlay = $StartOverlay

var quiz_list : Array = []    
var current_quiz_idx : int = 0  
var correct_count : int = 0    
var current_answer_id : int = 0 
var current_quiz_type : String = "" 

func _ready():
	quiz_list = DataManager.get_random_relics(5)
	current_quiz_idx = 0
	correct_count = 0
	if feedback_label:
		feedback_label.text = ""
	result_overlay.visible = false
	start_overlay.visible = true


func load_quiz():
	if feedback_label:
		feedback_label.text = ""
	
	for child in choice_container.get_children():
		child.queue_free()
		
	if current_quiz_idx >= 5:
		show_result()
		return
		
	var current_relic = quiz_list[current_quiz_idx]
	current_answer_id = current_relic["id"]
	
	current_quiz_type = "show_image" if randf() > 0.5 else "show_name"
	
	if current_quiz_type == "show_image":
		q_card.texture = load(current_relic["image_path"])
		q_card.visible = true
		q_card.modulate = Color(1, 1, 1, 1)
		q_label.text = "" 
	else:
		q_card.texture = null 
		q_label.text = current_relic["name"]
		
	var choices = []
	choices.append(current_relic) 
	
	var full_db = DataManager.relic_db.duplicate()
	full_db.shuffle()
	for relic in full_db:
		if relic["id"] != current_answer_id:
			choices.append(relic)
		if choices.size() == 3:
			break
			
	choices.shuffle() 
	
	for choice in choices:
		var btn = Button.new()
		

		btn.custom_minimum_size = Vector2(240, 240) 
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var style_box = StyleBoxTexture.new()
		

		style_box.texture_margin_left = 40
		style_box.texture_margin_right = 50
		style_box.texture_margin_top = 50
		style_box.texture_margin_bottom = 50
		
		style_box.content_margin_left = 40
		style_box.content_margin_right = 50
		style_box.content_margin_top = 50
		style_box.content_margin_bottom = 50
		
		if current_quiz_type == "show_image":

			var bg_path = DataManager.get_card_texture_path(choice["era"], false)
			style_box.texture = load(bg_path)
			
			var raw_name = choice["name"]
			var wrapped_name = ""
			
			for i in range(raw_name.length()):
				wrapped_name += raw_name[i]

				if (i + 1) % 5 == 0 and (i + 1) < raw_name.length():
					wrapped_name += "\n"
			
			btn.text = wrapped_name
			

			btn.add_theme_constant_override("outline_size", 0)
			btn.add_theme_font_size_override("font_size", 14) 
			btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
			

			btn.autowrap_mode = TextServer.AUTOWRAP_OFF 
			btn.clip_text = true
		else:
			var bg_path = DataManager.get_card_texture_path(choice["era"], true)
			style_box.texture = load(bg_path)
			
			btn.icon = load(choice["image_path"])
			btn.expand_icon = true 
			
			btn.icon = load(choice["image_path"])
			btn.expand_icon = true 
			btn.add_theme_constant_override("icon_max_width", 90)
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
			btn.text = ""
		
		btn.add_theme_stylebox_override("normal", style_box)
		btn.add_theme_stylebox_override("hover", style_box)
		btn.add_theme_stylebox_override("pressed", style_box)
		btn.add_theme_stylebox_override("disabled", style_box)
		
		btn.add_theme_color_override("font_color", Color(1, 1, 1))
		btn.add_theme_color_override("font_disabled_color", Color(0.7, 0.7, 0.7))
			
		btn.pressed.connect(func(): _on_choice_selected(choice["id"]))
		choice_container.add_child(btn)


func _on_choice_selected(selected_id: int):
	for btn in choice_container.get_children():
		btn.disabled = true
		
	if selected_id == current_answer_id:
		if feedback_label:
			feedback_label.text = "정답!"
		correct_count += 1
	else:
		if feedback_label:
			feedback_label.text = "오답!"
		
	await get_tree().create_timer(1.5).timeout
	current_quiz_idx += 1
	load_quiz()


func show_result():
	q_card.visible = false
	q_label.text = ""
	
	result_overlay.visible = true
	score_label.text = "5문제 중 " + str(correct_count) + "문제를 맞추셨습니다!"
	
	var stars = ""
	if correct_count == 5:
		stars = "⭐⭐⭐"
	elif correct_count >= 3:
		stars = "⭐⭐"
	elif correct_count >= 1:
		stars = "⭐"
	else:
		stars = "별이 없습니다"
		
	star_label.text = "획득한 별: " + stars


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_lobby_button_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://main_lobby.tscn")
	

func _on_start_button_pressed():
	start_overlay.visible = false 
	load_quiz()
