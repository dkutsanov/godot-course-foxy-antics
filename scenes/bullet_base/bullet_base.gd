extends Area2D

class_name Bullet

var _direction: Vector2 = Vector2.RIGHT
var _lifespan: float = 5.0
var _lifetime: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += _direction * delta
	check_expired(delta)

func check_expired(delta: float) -> void:
	_lifetime += delta
	if _lifetime > _lifespan:
		queue_free()

func setup(pos: Vector2, direction: Vector2, speed: float, lifespan) -> void:
	_direction = direction.normalized() * speed
	_lifespan = lifespan
	global_position = pos

func _on_area_entered(area: Area2D) -> void:
	queue_free()
