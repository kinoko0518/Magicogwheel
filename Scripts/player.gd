extends CharacterBody2D

@export var speed:float = 45
@onready var sprite:Sprite2D = $Sprite2D
var coords := Vector3(0, 0, 0):
	set(value):
		self.position = Vector2(value.x - value.z*2, value.z + value.z/2 + value.y*2)
		z_index = int(value.y)

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_axis("move_x_negative", "move_x_positive"),
		Input.get_axis("move_z_positive", "move_z_negative")
	)
	sprite.texture.pause = input == Vector2(0, 0)
	if input != Vector2(0, 0):
		sprite.flip_h = input.x < 0
		self.position += Vector2(input.x - input.y*2, input.y + input.x/2).normalized() * delta * speed
	move_and_slide()
