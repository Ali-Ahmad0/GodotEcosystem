class_name Creature
extends CharacterBody2D

# Properties
var speed : float = 25
var max_hunger : float = 100

@export var facing : String

@onready var state_timer : Timer = $StateTimer
@onready var target_collision : CollisionShape2D = $Target/CollisionShape2D
@onready var vision_collision : CollisionShape2D = $Vision/CollisionShape2D

# Facing direction
var direction : Vector2

# Current state
var current_state = "idle"

# Food target
var target : Node2D = null 
var hunger : float

func _ready() -> void:
	# Initialize the properties randomly
	max_hunger = randi_range(60, 120)
	hunger = max_hunger
	speed = randi_range(20, 40)
	
	# Initialize random vision radius
	vision_collision.shape.radius = randi_range(64, 128)
	
	# Assign the initial direction
	match facing.to_lower():
		"ne":
			direction = Direction.NE
		
		"nw":
			direction = Direction.NW
			
		"se":
			direction = Direction.SE
			
		"sw":
			direction = Direction.SW
		
		# Let default direction be NE
		_:
			direction = Direction.NE
	
	# Randomly set the initial state change time
	state_timer.wait_time = randf_range(2.0, 4.0)

func _process(delta: float) -> void:
	hunger = clampf(hunger, 0, max_hunger)

	# Die when hunger reaches 0
	if hunger <= 0:
		queue_free()
	
func _on_state_timer_timeout() -> void:
	# Randomly set state change time
	state_timer.wait_time = randf_range(2.0, 4.0)
	
	# Randomly set direction
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
	
	# Randomly switch between idle and wander
	var rand_val = randf()
	if rand_val < 0.5 and current_state != "chase":
		current_state = "wander" if current_state == "idle" else "idle"
		
# Food found
func _on_vision_area_entered(area: Area2D) -> void:
	target = area.get_parent()
	current_state = "chase"

# Hunger
func _on_hunger_timer_timeout() -> void:
	hunger -= 0.5 if current_state == "idle" else 1
