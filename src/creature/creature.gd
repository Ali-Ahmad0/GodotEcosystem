class_name Creature
extends CharacterBody2D

# Properties
var speed : float
var max_hunger : float
var hunger : float
var mating_percentage : float

# Initial facing direction
@export var facing : String

# The range in which max_hunger can lie
@export var hunger_lower_bound : int
@export var hunger_upper_bound : int

# A ratio of hunger : max_hunger
# At which the animal would eat
@export var hunger_eat_factor : float

# Scene variables
@onready var state_timer : Timer = $StateTimer
@onready var target_collision : CollisionShape2D = $Target/CollisionShape2D
@onready var vision : Area2D = $Vision
@onready var vision_collision : CollisionShape2D = $Vision/CollisionShape2D

# Name of group which species eats
var food_group : String = ""

# Name of group which eats species
var predator_group : String = ""

# Facing direction
var direction : Vector2

# Current state
var current_state = "idle"

# Food target
var target : Node2D = null
var threat : Node2D = null


func _ready() -> void:
	mating_percentage = 0
	
	# Initialize hunger randomly
	max_hunger = randi_range(
		hunger_lower_bound, 
		hunger_upper_bound
	)
	hunger = max_hunger
	
	# Initialize speed randomly
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
	
	if get_groups()[0].to_lower() == "predator":
		food_group = "prey"
		predator_group = ""
	
	elif get_groups()[0].to_lower() == "prey":
		food_group = "foliage"
		predator_group = "predator"


func _process(delta: float) -> void:
	hunger = clamp(hunger, 0, max_hunger)
	mating_percentage = clamp(mating_percentage, 0, 100)

	# Die when hunger reaches 0
	if hunger <= 0:
		queue_free()
		
	handle_vision()


# Is in a normal state
func is_normal_state() -> bool:
	return current_state == "idle" or current_state == "wander"


# Look for potential food or mate
func handle_vision() -> void:
	for area in vision.get_overlapping_areas():
		if !is_normal_state() or area.get_parent() == self:
			continue
			
		# Area belongs to creature of same species
		if area.is_in_group(self.get_groups()[0]):
			target = area.get_parent()
		
			# One of the 2 creatures is not ready to mate
			if !target.is_normal_state():
				target = null; continue
				
			if !(mating_percentage >= 100 and target.mating_percentage >= 100):
				target = null; continue
				
			current_state = "mate"; continue
			
		# Area belongs to the species' predator group
		if area.is_in_group(predator_group):
			threat = area.get_parent()
			current_state = "escape"; continue
		
		# Area belongs to the species' food group
		elif area.is_in_group(food_group.to_lower()):
			# Chase after food if sufficiently hungry
			if hunger / max_hunger < hunger_eat_factor:
				target = area.get_parent()
				current_state = "chase"; continue


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
	var rand_val : float = randf()
	if rand_val < 0.5 and is_normal_state():
		current_state = "wander" if current_state == "idle" else "idle"


# Increment/Decrement statistics
func _on_hunger_timer_timeout() -> void:
	# Decrement hunger based on activity
	hunger -= 1 if current_state == "idle" else 1.5
	
	# Randomly increment one's mating %age
	var rand_val : float = randf()
	if rand_val < 0.4:
		mating_percentage += 0.5
		
	elif rand_val > 0.8:
		mating_percentage += 1.5
		
	else:
		mating_percentage += 1


func _on_vision_area_exited(area: Area2D) -> void:
	if !area.get_parent().is_in_group(predator_group):
		return

	if current_state == "escape" and threat != null:
		threat.current_state = "idle"
		current_state = "wander"; threat = null
