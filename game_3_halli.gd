extends Control

@onready var turn_label = $TurnLabel
@onready var score_label = $ScoreLabel
@onready var opponent_card_ui = $CardContainer/OpponentCard
@onready var player_card_ui = $CardContainer/PlayerCard
@onready var deck_info_label = $DeckInfoLabel
@onready var start_overlay = $StartOverlay
@onready var result_overlay = $ResultOverlay
@onready var winner_label = $ResultOverlay/WinnerLabel

var active_relic_pool : Array = []
var player_deck : Array = []      
var opponent_deck : Array = []    

const P1_TYPE = "image"
const P2_TYPE = "text"

var matched_relic_ids : Array = []
var current_player_card = null
var current_opponent_card = null

var player_score : int = 0
var opponent_score : int = 0
var is_player_turn : bool = true  
var game_active : bool = false

func _ready():
	start_overlay.visible = true
	result_overlay.visible = false
	game_active = false
	clear_table()

func clear_table():
	opponent_card_ui.texture = null
	player_card_ui.texture = null
	if opponent_card_ui.has_node("Label"): opponent_card_ui.get_node("Label").text = ""
	if player_card_ui.has_node("Label"): player_card_ui.get_node("Label").text = ""
	current_player_card = null
	current_opponent_card = null

func setup_initial_game():
	active_relic_pool.clear()
	player_score = 0
	opponent_score = 0
	
	var all_relics = DataManager.relic_db.duplicate()
	all_relics.shuffle()
	for i in range(10):
		if all_relics.size() > 0:
			active_relic_pool.append(all_relics.pop_back())
	
	is_player_turn = true
			
	prepare_new_round()

func prepare_new_round():
	if active_relic_pool.is_empty():
		declare_final_winner()
		return

	player_deck.clear()
	opponent_deck.clear()
	matched_relic_ids.clear()
	clear_table()
	
	for relic in active_relic_pool:

		var p_content = relic["image_path"]
		player_deck.append({"id": relic["id"], "type": P1_TYPE, "content": p_content, "era": relic["era"]})
		
		var o_content = relic["name"]
		opponent_deck.append({"id": relic["id"], "type": P2_TYPE, "content": o_content, "era": relic["era"]})
		
	player_deck.shuffle()
	opponent_deck.shuffle()
	
	is_player_turn = true
	update_ui()
	next_turn()

func update_ui():
	score_label.text = "1P(나)(그림): " + str(player_score) + "점 | 2P(상대)(글자): " + str(opponent_score) + "점"
	deck_info_label.text = "남은 유물: " + str(active_relic_pool.size()) + "종"

func next_turn():
	if not game_active: return
	if player_deck.is_empty() and opponent_deck.is_empty():
		end_round_and_clean_deck()
		return
	if is_player_turn and player_deck.is_empty(): is_player_turn = false
	elif not is_player_turn and opponent_deck.is_empty(): is_player_turn = true
	turn_label.text = "★ 1P 턴!" if is_player_turn else "★ 2P 턴!"

func player_play_card():
	if not is_player_turn or player_deck.is_empty() or not game_active: return
	current_player_card = player_deck.pop_back()
	display_card(player_card_ui, current_player_card)
	is_player_turn = false
	next_turn()

func opponent_play_card():
	if is_player_turn or opponent_deck.is_empty() or not game_active: return
	current_opponent_card = opponent_deck.pop_back()
	display_card(opponent_card_ui, current_opponent_card)
	is_player_turn = true
	next_turn()



func display_card(ui_node, card_data):

	ui_node.custom_minimum_size = Vector2(320, 320)
	

	var style_box = StyleBoxTexture.new()
	_apply_stylebox_margins(style_box)
	var bg_path = DataManager.get_card_texture_path(card_data["era"], true) 
	style_box.texture = load(bg_path)
	

	ui_node.texture = style_box.texture
	ui_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ui_node.stretch_mode = TextureRect.STRETCH_SCALE


	if card_data["type"] == "image":
		if ui_node.has_node("Label"): 
			ui_node.get_node("Label").text = ""
		
		var img_node = ui_node.get_node_or_null("ArtifactIcon")
		if not img_node:
			img_node = TextureRect.new()
			img_node.name = "ArtifactIcon"
			ui_node.add_child(img_node)
			
		img_node.texture = load(card_data["content"])
		img_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		img_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		

		img_node.custom_minimum_size = Vector2(160, 160) 
		img_node.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		img_node.position = (ui_node.size / 2) - (img_node.size / 2)
		img_node.visible = true
		
	else:

		if ui_node.has_node("ArtifactIcon"):
			ui_node.get_node("ArtifactIcon").visible = false
			
		if ui_node.has_node("Label"): 
			var label = ui_node.get_node("Label")
			

			var raw_name = card_data["content"]
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
				
			label.text = wrapped_name
			

			label.add_theme_color_override("font_color", Color(0, 0, 0)) 
			label.add_theme_font_size_override("font_size", 16)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)


func _input(event):
	if not game_active: return
	if event is InputEventKey and event.pressed and not event.echo:
		if (event.keycode == KEY_SPACE) and is_player_turn: player_play_card()
		elif (event.keycode == KEY_SHIFT) and not is_player_turn: opponent_play_card()
		if event.keycode == KEY_ENTER: trigger_bell("player")
		elif event.keycode == KEY_Z: trigger_bell("opponent")

func trigger_bell(who_pressed):
	if current_player_card == null or current_opponent_card == null: return
	var target_id = current_player_card["id"]
	var is_match = (target_id == current_opponent_card["id"])
	if target_id in matched_relic_ids: return
	
	if is_match:
		if who_pressed == "player": player_score += 10
		else: opponent_score += 10
		matched_relic_ids.append(target_id)
		turn_label.text = "🎯 매칭 성공!"
	else:
		turn_label.text = "❌ 오답!"
	update_ui()

func end_round_and_clean_deck():
	game_active = false
	turn_label.text = "🔄 라운드 정산 중..."
	await get_tree().create_timer(1.0).timeout
	var remaining = []
	for relic in active_relic_pool:
		if not relic["id"] in matched_relic_ids: remaining.append(relic)
	active_relic_pool = remaining
	
	if player_score >= 30 or opponent_score >= 30 or active_relic_pool.is_empty():
		declare_final_winner()
	else:
		game_active = true
		prepare_new_round()

func declare_final_winner():
	game_active = false
	result_overlay.visible = true
	
	var winner_text = ""
	if player_score > opponent_score:
		winner_text = "🎉 1P(나) 승리!"
	elif opponent_score > player_score:
		winner_text = "💻 2P(상대) 승리!"
	else:
		winner_text = "🤝 무승부!"
		
	winner_label.text = "%s\n\n최종 점수\n1P: %d점 | 2P: %d점" % [winner_text, player_score, opponent_score]

func _apply_stylebox_margins(sb: StyleBoxTexture):
	sb.texture_margin_left = 40
	sb.texture_margin_right = 50
	sb.texture_margin_top = 50
	sb.texture_margin_bottom = 50
	
	sb.content_margin_left = 40
	sb.content_margin_right = 50
	sb.content_margin_top = 50
	sb.content_margin_bottom = 50

func _on_start_button_pressed():
	start_overlay.visible = false
	game_active = true
	setup_initial_game()

func _on_lobby_button_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://main_lobby.tscn")
