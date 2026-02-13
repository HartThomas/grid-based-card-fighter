extends Resource

class_name Tile

@export_enum('wall', 'nothing') var terrain = 'wall'
@export var entity : Entity = null

func set_entity(ent: Entity) ->void:
	entity = ent
