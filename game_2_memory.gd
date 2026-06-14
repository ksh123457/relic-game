extends Control


@onready var grid_container = $GridContainer
@onready var timer_label = $TimerLabel
@onready var result_overlay = $ResultOverlay
@onready var time_result_label = $ResultOverlay/TimeResultLabel
@onready var start_overlay = $StartOverlay 


var memory_deck : Array = []     
var selected_cards : Array = []    
var matched_pairs : int = 0         


var elapsed_time : float = 0.0     
var is_game_over : int = 0       

func _ready():
	result_overlay.visible = false
	elapsed_time = 0.0
	matched_pairs = 0
	
	is_game_over = 0
	timer_label.text = "시간: 0.0초"
	

	start_overlay.visible = true

func _process(delta):

	if is_game_over == 1:
		elapsed_time += delta
		timer_label.text = "시간: " + str(snapped(elapsed_time, 0.1)) + "초"


func setup_memory_game():
	for child in grid_container.get_children():
		child.queue_free()
		
	var chosen_relics = DataManager.get_random_relics(4)
	
	memory_deck.clear()
	for relic in chosen_relics:
		memory_deck.append({
			"id": relic["id"],
			"type": "image",
			"content": relic["image_path"],
			"name": relic["name"],
			"era": relic["era"]
		})
		memory_deck.append({
			"id": relic["id"],
			"type": "text",
			"content": relic["name"],
			"name": relic["name"],
			"era": relic["era"]
		})
		
	memory_deck.shuffle()
	
	for i in range(memory_deck.size()):
		var card_info = memory_deck[i]
		var btn = Button.new()
		
		# 1. 퀴즈 스크립트의 카드 크기 규격 적용 (320x320)
		btn.custom_minimum_size = Vector2(320, 320)
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var style_box = StyleBoxTexture.new()
		_apply_stylebox_margins(style_box)
		
		var bg_path = DataManager.get_card_texture_path(card_info["era"], false) # 뒷면(false)
		style_box.texture = load(bg_path)
		_set_card_stylebox(btn, style_box)
		

		btn.text = "?"
		btn.add_theme_constant_override("outline_size", 0)
		btn.add_theme_font_size_override("font_size", 14)
		btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
		btn.add_theme_color_override("font_color", Color(1, 1, 1))
		btn.add_theme_color_override("font_hover_color", Color(1, 1, 1))
		btn.add_theme_color_override("font_focus_color", Color(1, 1, 1))
		btn.add_theme_color_override("font_disabled_color", Color(0.7, 0.7, 0.7))
		
		btn.set_meta("card_info", card_info)
		btn.set_meta("is_flipped", false)
		
		btn.pressed.connect(func(): _on_card_pressed(btn))
		grid_container.add_child(btn)



func _on_card_pressed(clicked_btn: Button):
	if clicked_btn.get_meta("is_flipped") or selected_cards.size() >= 2:
		return
		
	var info = clicked_btn.get_meta("card_info")
	clicked_btn.set_meta("is_flipped", true)
	

	var style_box = StyleBoxTexture.new()
	_apply_stylebox_margins(style_box)
	var bg_path = DataManager.get_card_texture_path(info["era"], true) # 앞면(true)
	style_box.texture = load(bg_path)
	_set_card_stylebox(clicked_btn, style_box)
	

	if info["type"] == "image":
		clicked_btn.text = ""
		clicked_btn.icon = load(info["content"])
		clicked_btn.expand_icon = true
		

		clicked_btn.add_theme_constant_override("icon_max_width", 100)
		clicked_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		clicked_btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	else:
		var raw_name = info["content"]
		var words = raw_name.split(" ")
		var wrapped_name = ""
		var current_line = ""
		
		for word in words:
			if current_line.length() > 0 and (current_line.length() + word.length()) > 5:
				wrapped_name += current_line.strip_edges() + "\n"
				current_line = word + " "
			else:
				current_line += word + " "
		
		wrapped_name += current_line.strip_edges()
		
		if wrapped_name == "":
			wrapped_name = raw_name
				
		clicked_btn.text = wrapped_name
		clicked_btn.icon = null
		
		clicked_btn.add_theme_color_override("font_color", Color(0, 0, 0))
		clicked_btn.add_theme_color_override("font_hover_color", Color(0, 0, 0))
		clicked_btn.add_theme_color_override("font_focus_color", Color(0, 0, 0))
		
		clicked_btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		clicked_btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
		clicked_btn.clip_text = false
		
	selected_cards.append(clicked_btn)
	
	if selected_cards.size() == 2:
		check_card_match()


func check_card_match():
	var card1 = selected_cards[0]
	var card2 = selected_cards[1]
	
	var info1 = card1.get_meta("card_info")
	var info2 = card2.get_meta("card_info")
	
	if info1["id"] == info2["id"] and info1["type"] != info2["type"]:
		matched_pairs += 1
		selected_cards.clear()
		
		if matched_pairs >= 4:
			game_clear()
	else:
		await get_tree().create_timer(1.0).timeout
		for card in selected_cards:
			var info = card.get_meta("card_info")
			card.set_meta("is_flipped", false)

			var style_box = StyleBoxTexture.new()
			_apply_stylebox_margins(style_box)
			var bg_path = DataManager.get_card_texture_path(info["era"], false)
			style_box.texture = load(bg_path)
			_set_card_stylebox(card, style_box)
			

			card.text = "?"
			card.icon = null
			

			card.add_theme_color_override("font_color", Color(1, 1, 1))
			card.add_theme_color_override("font_hover_color", Color(1, 1, 1))
			card.add_theme_color_override("font_focus_color", Color(1, 1, 1))
			
		selected_cards.clear()


func game_clear():
	is_game_over = 0
	result_overlay.visible = true
	time_result_label.text = "기록: " + str(snapped(elapsed_time, 0.1)) + "초 만에\n모든 유물의 짝을 찾았습니다!"



func _apply_stylebox_margins(sb: StyleBoxTexture):
	sb.texture_margin_left = 40
	sb.texture_margin_right = 50
	sb.texture_margin_top = 50
	sb.texture_margin_bottom = 50
	
	sb.content_margin_left = 40
	sb.content_margin_right = 50
	sb.content_margin_top = 50
	sb.content_margin_bottom = 50


func _set_card_stylebox(btn: Button, sb: StyleBoxTexture):
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_stylebox_override("hover", sb)
	btn.add_theme_stylebox_override("pressed", sb)
	btn.add_theme_stylebox_override("disabled", sb)


func _on_lobby_button_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://main_lobby.tscn")


func _on_start_button_pressed():
	start_overlay.visible = false 
	is_game_over = 1              
	setup_memory_game()
