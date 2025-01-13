extends CharacterBody2D

class_name Player
 
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shooter: Shooter = $Shooter


enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

const GRAVITY: float = 690.0
const RUN_SPEED: float = 120.0
const SPRINT_SPEED: float = RUN_SPEED * 1.5
const MAX_FALL: float = 400.0
const JUMP_VELOCITY: float = -260.0

var _state: PlayerState = PlayerState.IDLE
var _double_jump_available: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_state()
	update_debug_label()

func shoot() -> void:
	if sprite_2d.flip_h:
		shooter.shoot(Vector2.LEFT)
	else:
		shooter.shoot(Vector2.RIGHT)

func get_input() -> void:
	
	velocity.x = 0
	
	if is_on_floor():
		_double_jump_available = true
	
	if Input.is_action_pressed("left"):
		sprite_2d.flip_h = true
		if Input.is_action_pressed("sprint"):
			velocity.x = -SPRINT_SPEED
		else:
			velocity.x = -RUN_SPEED
	elif Input.is_action_pressed("right"):
		sprite_2d.flip_h = false
		if Input.is_action_pressed("sprint"):
			velocity.x = +SPRINT_SPEED
		else:
			velocity.x = +RUN_SPEED
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif _double_jump_available:
			velocity.y = JUMP_VELOCITY
			_double_jump_available = false
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func update_debug_label() -> void:
	debug_label.text = "floor: %s\n%s\nvel %.0f, %.0f)" % [
		is_on_floor(), PlayerState.keys()[_state], velocity.x, velocity.y
	]

func calculate_state() -> void:
	if is_on_floor():
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)
		else:
			set_state(PlayerState.JUMP)

func set_state(new_state: PlayerState) -> void:
	if _state == new_state:
		return
	
	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animation_player.play("idle")
		PlayerState.RUN:
			animation_player.play("run")
		PlayerState.JUMP:
			animation_player.play("jump")
		PlayerState.FALL:
			animation_player.play("fall")
