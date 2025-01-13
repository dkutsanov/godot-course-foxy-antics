extends Node2D

class_name Shooter

@onready var shooter_timer: Timer = $ShooterTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var speed: float = 300.0
@export var lifespan: float = 10.0
@export var bullet_key: Constants.ObjectType
@export var shoot_delay: float = 0.7

var _can_shoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooter_timer.wait_time = shoot_delay

func shoot(direction: Vector2) -> void:
	if !_can_shoot:
		return
		
	_can_shoot = false
	
	SignalManager.on_create_bullet.emit(
		global_position,
		direction,
		lifespan,
		speed,
		bullet_key
	)
	
	shooter_timer.start()


func _on_shooter_timer_timeout() -> void:
	_can_shoot = true
