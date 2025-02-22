@tool
extends Node2D
class_name Equipment

@export var y_coords_when_begin:float = 1.0
@export var tlc:TileMapContainer
@export var pos:Vector3:
	set(value):
		self.position = convert_coords_3d_to_2d(value)
		self.z_index = int(pos.y) + 1
		pos = value
@export var accelation:Vector3

func convert_coords_3d_to_2d(vec3:Vector3) -> Vector2:
	return Vector2(vec3.x + vec3.z, -vec3.z/2 + vec3.x/2 - vec3.y) * 16

func _ready() -> void:
	if get_parent() is not TileMapContainer:
		push_error("Equipment must be belonging to TileMapContainer")
	else: tlc = get_parent()

func special_ceil(input:float):
	if input < 0: return floor(input)
	else: return ceil(input)

func physics():
	var current_height  = tlc.get_height(Vector3i(pos))
	var x_future_height = tlc.get_height(Vector3i(Vector3(special_ceil(pos.x + accelation.x), pos.y, pos.z)))
	var z_future_height = tlc.get_height(Vector3i(Vector3(pos.x, pos.y, special_ceil(pos.z + accelation.z))))
	var allowed_step    = 0.05
	
	if abs(current_height - x_future_height) <= allowed_step:
		self.pos.x += accelation.x
	if abs(current_height - z_future_height) <= allowed_step:
		self.pos.z += accelation.z
	self.pos.y += accelation.y

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		physics()
		gravity()

func is_on_floor() -> bool:
	var is_on_fullblock = tlc.get_height(Vector3i(pos) - Vector3i(0, 1, 0)) == 1.0
	if is_on_fullblock:
		return true
	var block_height = tlc.get_height(Vector3i(pos))
	if pos.y - Vector3i(pos).y < block_height:
		return true
	return false

func gravity() -> void:
	if not is_on_floor():
		self.accelation.y -= 0.0015
	elif self.accelation.y < 0:
		self.accelation.y = 0
