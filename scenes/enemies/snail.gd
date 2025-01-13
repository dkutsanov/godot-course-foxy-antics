extends EnemyBase

@onready var floor_detection: RayCast2D = $FloorDetection
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = speed if animated_sprite_2d.flip_h else -speed
	
	move_and_slide()
		
	if is_on_floor():
		if is_on_wall() or !floor_detection.is_colliding():
			flip_me()

func flip_me() -> void:
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x = -floor_detection.position.x
