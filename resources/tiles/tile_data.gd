extends Resource

class_name Tile

@export_enum('wall', 'nothing') var terrain = 'wall'
@export var entity : EntityInstance = null

func set_entity(ent: EntityInstance) ->void:
	entity = ent
