extends EnemyAttack

class_name RangedAttack

var projectile_scene: PackedScene =  preload("res://gameplay/projectiles/projectile.tscn")
@export var projectile_data : ProjectileData

func execute(attacker, target):
	print('arrow loosing')
	var proj = projectile_scene.instantiate()
	projectile_data.target = target
	projectile_data.attackers_pos = attacker.global_position
	projectile_data.damage = attacker.data.get_attack_damage()
	proj.global_position = attacker.global_position + Vector2(16,16)
	proj.data = projectile_data
	attacker.get_parent().add_child(proj)
