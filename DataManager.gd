extends Node

enum Era {
	PALEOLITHIC,          
	NEOLITHIC,           
	BRONZE_AGE,          
	PROTO_THREE_KINGDOMS, 
	THREE_KINGDOMS,       
	GORYEO,             
	JOSEON                
}

func get_era_name(era_type: Era) -> String:
	match era_type:
		Era.PALEOLITHIC: return "구석기 시대"
		Era.NEOLITHIC: return "신석기 시대"
		Era.BRONZE_AGE: return "청동기 시대"
		Era.PROTO_THREE_KINGDOMS: return "원삼국 시대"
		Era.THREE_KINGDOMS: return "삼국 시대"
		Era.GORYEO: return "고려 시대"
		Era.JOSEON: return "조선 시대"
		_: return "알 수 없는 시대"


func get_card_texture_path(era_value: int, is_front: bool = true) -> String:
	var age_num := 1
	
	match era_value:
		Era.PALEOLITHIC: age_num = 1         
		Era.NEOLITHIC: age_num = 2         
		Era.BRONZE_AGE: age_num = 3         
		Era.PROTO_THREE_KINGDOMS: age_num = 4 
		Era.THREE_KINGDOMS: age_num = 5       
		Era.GORYEO: age_num = 6              
		Era.JOSEON: age_num = 7               
		
	var suffix := "F" if is_front else "B"
	
	return "res://relics/AGE%d%s.png" % [age_num, suffix]


var relic_db : Array = [
	{
		"id": 1,
		"name": "주먹도끼",
		"era": Era.PALEOLITHIC,
		"image_path": "res://relics/relic1.png",
		"description": "경기도 연천 삼화리에서 지표 채집한 주먹도끼로 적갈색 규암을 사용하여 만들었습니다. 용도는 짐승을 사냥하거나 땅을 파는 등 다양하게 사용하였습니다."
	},
	{
		"id": 2,
		"name": "뚜르개",
		"era": Era.PALEOLITHIC,
		"image_path": "res://relics/relic2.png",
		"description": "경기도 연천 횡산리에서 지표 채집한 뚜르개로 황갈색 규암을 가공하여 만든 뚜르개 입니다. 가죽을 뚫거나 하는 용도로 사용하였습니다."
	},
	{
		"id": 3,
		"name": "돌망치",
		"era": Era.PALEOLITHIC,
		"image_path": "res://relics/relic3.png",
		"description": "경상북도 성주 취곡리에서 지표 채집한 구석기시대 돌망치 입니다. 석기를 만들거나 음식물을 깨거나 부술 때 사용한 것으로 보입니다."
	},
	{
		"id": 4,
		"name": "빗살무늬토기 깊은바리",
		"era": Era.NEOLITHIC,
		"image_path": "res://relics/relic4.png",
		"description": "김천 송죽리 신석기시대 집자리에서 출토된 빗살무늬토기는 대동강 유역และ 한강 유역 등 한반도 중서부 지역의 신석기문화가 경북 내륙지역에도 파급되었음을 보여주는 좋은 자료입니다. 특히 다양한 무늬를 가진 빗살무늬토기 파편들은 지금으로부터 약 5000년 전 사람들의 해학과 여유도 느끼게 해줍니다."
	},
	{
		"id": 5,
		"name": "흑요석",
		"era": Era.NEOLITHIC,
		"image_path": "res://relics/relic5.png",
		"description": "울산 신암리 유적에서 출토된 신석기시대 흑요석은 화산지대에서만 나오는 흑요석의 특성을 생각할 때 앞으로 신석기 시대의 교류범위를 밝힐 좋은 자료가 될 것이라고 여겨집니다."
	},
	{
		"id": 6,
		"name": "비파형동검1",
		"era": Era.BRONZE_AGE,
		"image_path": "res://relics/relic6.png",
		"description": "청도 예전동에서 출토된 것으로 전해지는 비파형동검은 왼편 아래 부분에 땜질로 보수한 흔적이 있어 흥미롭습니다. 비파형동검은 고조선식 동검이라고도 불리며 중국 요서지방에서 주로 출토되는 유형이어서 어떤 과정으로 경북 청도까지 흘러들어오게 되었는가의 의문을 던져주는 국보급 유물입니다."
	},
	{
		"id": 7,
		"name": "비파형동검2",
		"era": Era.BRONZE_AGE,
		"image_path": "res://relics/relic7.png",
		"description": "김천 송죽리 지석묘 앞에서 날끝이 지표에 꽂힌 상태로 출토된 비파형 동검은 지석묘사회가 비파형동검 문화를 받아들이고 또 장례나 장송의례로 활용하였음을 보여주는 좋은 자료입니다."
	},
	{
		"id": 8,
		"name": "돌대문토기 깊은바리",
		"era": Era.BRONZE_AGE,
		"image_path": "res://relics/relic8.png",
		"description": "김천 송죽리 집자리에서 출토된 청동기시대 가장 빠른 시기의 돌대문토기는 앞으로 우리나라 정착 농경생활의 토대가 만들어진 청동기시대의 연구에 중요한 자료가 될 것으로 여겨집니다."
	},
	{
		"id": 9,
		"name": "붉은간토기 항아리",
		"era": Era.BRONZE_AGE,
		"image_path": "res://relics/relic9.png",
		"description": "주로 지석묘에서 출토되는 붉은 간토기는 고운 태토와 마연한 표면과 붉은 칠, 그리고 얇은 두께 등을 특징으로 하며 붉은색은 아마도 재생이나 부활을 상징하는 의미로도 추정됩니다. 하지만 이 붉은 간토기는 지석묘에서가 아니라 주거지에서 출토된 것입니다."
	},
	{
		"id": 10,
		"name": "거푸집",
		"era": Era.PROTO_THREE_KINGDOMS,
		"image_path": "res://relics/relic10.png",
		"description": "경주 황성동에서 발굴된 원삼국시대의 철기 제작 과정에서 나온 쇠똥이나 흙으로 만든 거푸집은 신라 성장의 정치적·경제적·기술적 토대를 보여주는 귀중한 자료입니다."
	},
	{
		"id": 11,
		"name": "오리모양토기",
		"era": Era.PROTO_THREE_KINGDOMS,
		"image_path": "res://relics/relic11.png",
		"description": "고운 흙으로 만든 오리모양토기는 원삼국시대 무덤에서 나오는 유물로 죽은 사람을 다음 세계로 인도하는 역할을 한 것으로 추정됩니다. 아마도 오리가 걷고 수영도 하며 날 수 있다는 점에서 다음 세계로 가는데 필요한 기능을 모두 가지고 있다고 생각하여 부장품으로 채택하지 않았나 추정됩니다. 또 새가 영혼을 다음 세상으로 인도한다는 인식을 선사와 고대인들이 가지고 있었던 것으로 생각됩니다. 자세히 보면 형태가 오리인 것 같기도 하면서 머리에 벼슬이 있는 점 등으로 보아 봉황으로 보는 견해도 있습니다."
	},
	{
		"id": 12,
		"name": "굽다리접시",
		"era": Era.THREE_KINGDOMS,
		"image_path": "res://relics/relic12.png",
		"description": "고령 지산동 고분에서 출토된 대가야 양식의 굽다리접시는 삿갓모양의 뚜껑손잡이, 점열문양의 뚜껑, 일렬로 배치된 굽다리의 투창, 접시의 얕은 깊이 등의 특징이 있습니다."
	},
	{
		"id": 13,
		"name": "닭·생선뼈가 담긴 굽다리접시",
		"era": Era.THREE_KINGDOMS,
		"image_path": "res://relics/relic13.png",
		"description": "고령 지산동 고분군에서 출토된 굽다리 접시에는 고동, 생선뼈 등이 나왔고 또 경산 임당 등지에서는 상어뼈가 나왔는데 이는 고대의 제사용품이 무엇이었는가를 알려주는 좋은 자료입니다. 그리고 상어뼈 등은 돔배기 제사 전통이 적어도 지금부터 1,500년 전까지 소급될 수 있음을 암시하기도 합니다."
	},
	{
		"id": 14,
		"name": "청자 연꽃 무늬 항아리",
		"era": Era.GORYEO,
		"image_path": "res://relics/relic14.png",
		"description": "몸통에 연화문을 음각한 4개의 귀가 달린 청자 항아리로서 계명대학교 행소박물관의 대표적인 청자입니다."
	},
	{
		"id": 15,
		"name": "분청사기 넝쿨 무늬 장군",
		"era": Era.JOSEON,
		"image_path": "res://relics/relic15.png",
		"description": "활달한 넝쿨 무늬와 질감 등으로 보아 아무것에도 거리낌 없는 당시 도공의 마음 상태를 보여주는 것 같습니다. 철화 분청은 주로 대전 계룡산 분청사기 요지에서 구워진 것으로 알려져 있습니다."
	},
	{
		"id": 16,
		"name": "분청사기 꽃과 새 무늬 납작 병",
		"era": Era.JOSEON,
		"image_path": "res://relics/relic16.png",
		"description": "자연스럽고 부담없는 문양과 서민적 분위기 등으로 우리에게 아주 친숙한 유물입니다. 이 분청사기 납작병은 조선 전기에 만들어진 것입니다."
	},
	{
		"id": 17,
		"name": "분청사기 덤벙 무늬 대접",
		"era": Era.JOSEON,
		"image_path": "res://relics/relic17.png",
		"description": "유약이 담긴 그릇에 그릇을 덤벙 담궈 문양을 만들었음을 보여줍니다. 아주 자연스럽고 대담한 시도라 하지 않을 수 없습니다."
	},
	{
		"id": 18,
		"name": "백자 복숭아 모양 연적",
		"era": Era.JOSEON,
		"image_path": "res://relics/relic18.png",
		"description": "나뭇잎은 청색으로, 가지는 구리로 붉은색을 낸 백자 복숭아 모양 연적입니다. 이 연적의 주인은 먹물을 만들면서 오래 살기를 기원하며 천도복숭아를 만지는 기분을 가졌을 것으로 추정됩니다."
	},
	{
		"id": 19,
		"name": "나무로 만들어진 등잔 받침",
		"era": Era.JOSEON,
		"image_path": "res://relics/relic19.png",
		"description": "초롱을 밝히는 나무로 된 등잔 받침은 조선시대 우리 선조들의 자연스럽지만 대담한 서민적 미의식을 잘 보여줍니다."
	}
]


func get_random_relics(count: int) -> Array:
	var temp_list = relic_db.duplicate()
	temp_list.shuffle()
	return temp_list.slice(0, count)


func get_relics_by_era(target_era: Era) -> Array:
	var filtered_list = []
	for relic in relic_db:
		if relic["era"] == target_era:
			filtered_list.append(relic)
	return filtered_list
