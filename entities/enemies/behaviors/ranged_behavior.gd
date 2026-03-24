extends EnemyBehavior

func get_intent(enemy: EnemyContainer):
	var distance = enemy.position.distance_to(enemy.get_player_pos())
	
	if distance < 100:
		enemy.state = enemy.States.COWARD
	elif distance > 200:
		enemy.state = enemy.States.AGGRO
	else:
		enemy.state = enemy.States.ATTACK
