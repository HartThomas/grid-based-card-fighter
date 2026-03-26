extends EnemyBehavior

class_name MeleeBehavior

func get_intent(enemy: EnemyContainer):
	var distance = enemy.position.distance_to(enemy.get_player_pos())
	
	match enemy.state:
		enemy.States.ATTACK:
			if distance >= 64:
				enemy.set_state(enemy.States.AGGRO)
		enemy.States.IDLE:
			if distance < 200:
				enemy.set_state(enemy.States.AGGRO)
		enemy.States.AGGRO:
			if distance < 64:
				enemy.set_state(enemy.States.ATTACK)
