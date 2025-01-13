extends Node2D

const OBJECT_SCENES: Dictionary = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/bullet_base/bullet_player.tscn"),
	Constants.ObjectType.BULLET_ENEMY:  preload("res://scenes/bullet_base/bullet_enemy.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.on_create_bullet.connect(on_create_bullet) 

func on_create_bullet(
	position: Vector2,
	direction: Vector2,
	lifespan: float,
	speed: float,
	object_type: Constants.ObjectType) -> void:
		
		if !OBJECT_SCENES.has(object_type):
			return

		var new_bullet: Bullet = OBJECT_SCENES[object_type].instantiate()
		new_bullet.setup(position, direction, speed, lifespan)
		call_deferred("add_child", new_bullet)
