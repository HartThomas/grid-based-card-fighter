extends Resource

class_name CardManager

@export var cards_owned : Array[CardInstance] = []
@export var deck : Array[CardInstance] = []
@export var hand : Array[CardInstance] = []
@export var spent : Array[CardInstance] = []

func draw_card() -> CardInstance:
	if deck.is_empty():
		reshuffle_spent_into_deck()
	if deck.is_empty():
		print('Trying to draw but nothing in deck or spent pile')
		return null  # nothing left to draw
	var card = deck.pop_front()
	hand.append(card)
	return card

func draw_cards(amount: int) -> Array[CardInstance]:
	var drawn : Array[CardInstance] = []
	for i in amount:
		var card = draw_card()
		if card:
			drawn.append(card)
		else:
			break
	return drawn

func use_card(card: CardInstance) -> void:
	if not hand.has(card):
		print('Trying to use ', card,' but it isnt in hand')
		return
	hand.erase(card)
	spent.append(card)

func discard_card(card: CardInstance) -> void:
	if not hand.has(card):
		print('Trying to discard ', card,' but it isnt in hand')
		return
	hand.erase(card)
	spent.append(card)

func reshuffle_spent_into_deck() -> void:
	if spent.is_empty():
		return
	deck.append_array(spent)
	spent.clear()
	deck.shuffle()

func add_card_to_deck(card: CardInstance) -> void:
	cards_owned.append(card)
	deck.append(card)

func remove_card(card: CardInstance) -> void:
	cards_owned.erase(card)
	deck.erase(card)
	hand.erase(card)
	spent.erase(card)

func start_combat() -> void:
	deck = cards_owned.duplicate()
	hand.clear()
	spent.clear()
	deck.shuffle()

func get_number_of_cards_deck() -> int:
	return deck.size()

func get_number_of_cards_spent() -> int:
	return spent.size()
