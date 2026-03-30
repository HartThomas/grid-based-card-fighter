extends EnemyAttack

class_name RangedAttack

@export var projectile_scene: PackedScene

func execute(attacker, target):
	var proj = projectile_scene.instantiate()
	proj.global_position = attacker.global_position
	proj.target = target
	attacker.get_parent().add_child(proj)
