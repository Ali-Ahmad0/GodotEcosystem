class_name Stag
extends Creature

@export var max_speed : float = 50.0
@export var acceleration : float = 100.0

@onready var timer : Timer = $Timer

enum Direction 
{
	NE,
	NW,
	SE, 
	SW
}

var north_east : Vector2 = Vector2(1, -0.5).normalized()
var north_west : Vector2 = Vector2(-1, -0.5).normalized()
var south_east : Vector2 = Vector2(1, 0.5).normalized()
var south_west : Vector2 = Vector2(-1, 0.5).normalized()

@export var direction : Direction = Direction.NE

var current_state = "idle"

func _ready() -> void:
	timer.wait_time = randf_range(2.0, 4.0)

func _process(delta: float) -> void:
	match direction:
		Direction.NE:
			velocity = north_east
		
		Direction.NW:
			velocity = north_west
		
		Direction.SE:
			velocity = south_east
			
		Direction.SW:
			velocity = south_west
			
		_:
			pass
			
	velocity *= speed if current_state != "idle" else 0

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(2.0, 4.0)
	var dir_indx : int = randi_range(0, 3)
		
	match dir_indx:
		0:
			direction = Direction.NE
		1:
			direction = Direction.NW
		2:
			direction = Direction.SE
		3:
			direction = Direction.SW
		_:
			pass
	
	var rand_val = randf()
	if rand_val < 0.5:
		current_state = "wander" if current_state == "idle" else "idle"
