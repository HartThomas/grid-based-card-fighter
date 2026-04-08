extends EnemyBehavior

class_name RangedBehavior

func get_intent(enemy: EnemyContainer):
	var distance = enemy.position.distance_to(enemy.get_player_pos())
	
	match enemy.state:
		enemy.States.ATTACK:
			if distance < 100:
				enemy.set_state(enemy.States.COWARD)
			elif distance > 200:
				enemy.set_state(enemy.States.AGGRO)
		enemy.States.IDLE:
			if distance < 250:
				enemy.set_state(enemy.States.AGGRO)
			elif distance < 100:
				enemy.set_state(enemy.States.COWARD)
		enemy.States.AGGRO:
			if distance > 100 and distance <200:
				enemy.set_state(enemy.States.ATTACK)
			elif distance < 100:
				enemy.set_state(enemy.States.COWARD)
			elif distance >200:
				enemy.set_state(enemy.States.AGGRO)
		enemy.States.COWARD:
			if distance > 200:
				enemy.set_state(enemy.States.AGGRO)
			elif distance > 100:
				enemy.set_state(enemy.States.ATTACK)
