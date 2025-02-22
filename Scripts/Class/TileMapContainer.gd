extends Node2D
class_name TileMapContainer

@export var tile_set:TileSet
@export var tiles:Dictionary[int, TileMapLayer] = {}

func create_new_y(new_y) -> TileMapLayer:
	var new_layer = TileMapLayer.new()
	new_layer.tile_set = tile_set
	new_layer.y_sort_enabled = true
	new_layer.z_index = new_y
	return new_layer

func unwrap_coords(vec3_coords:Vector3i) -> Vector2i:
	return Vector2i(
		(vec3_coords.x >> 1) + (vec3_coords.z >> 1) + abs((vec3_coords.z % 2) * (vec3_coords.x % 2)),
		-vec3_coords.y * 2 + vec3_coords.x - vec3_coords.z
	)

func set_cube(coords:Vector3i, source_id:int, atlas_coords:Vector2i):
	if not tiles.keys().has(coords.y):
		var new_y = create_new_y(coords.y)
		add_child(new_y)
		tiles.set(coords.y, new_y)
	tiles.get(coords.y).set_cell(unwrap_coords(coords), source_id, atlas_coords)

func get_tile_data(coords:Vector3i, property_name:String):
	if tiles.has(coords.y):
		var data = tiles[coords.y].get_cell_tile_data(unwrap_coords(coords))
		if data:
			return data.get_custom_data(property_name)
		else:
			return null
	else:
		return null

func get_height(coords:Vector3i) -> float:
	var result = get_tile_data(coords, "height")
	if result == null:
		return 0
	return result
