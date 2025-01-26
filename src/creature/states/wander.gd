class_name Wander
extends State

@export var agent : Creature
@export var animator : AnimatedSprite2D
@export var navigation : NavigationAgent2D

func enter() -> void:
	animate()

func update(_delta: float) -> void:
	animate()
		
	# Exit the state
	if agent.current_state != self.name.to_lower():
		emit_signal("state_transition", self, agent.current_state)

	# Calculate the future position
	var next_position : Vector2 = agent.global_position + (agent.direction * 48)
	navigation.target_position = next_position
	
	# If moving outside navigation region
	if not navigation.is_target_reachable():
		# Change direction
		agent.direction = get_rand_direction(agent.direction)
		
	agent.velocity = agent.direction * agent.speed
	agent.move_and_slide()
	
func animate() -> void:
	# Animate the creature
	match agent.direction:
		Direction.NE:
			animator.play("run_ne")
			
		Direction.NW:
			animator.play("run_nw")
			
		Direction.SE:
			animator.play("run_se")
			
		Direction.SW:
			animator.play("run_sw")
			
# Returns a random direction to switch to
# Based on current direction at dead end
func get_rand_direction(curr_dir : Vector2) -> Vector2:
	# All possible directions
	var directions : Array = [
		Direction.NE,
		Direction.NW,
		Direction.SE,
		Direction.SW
	]
	
	# Return any direction other than the current direction
	var valid_next = directions.filter(func(element): return element != curr_dir)
	return valid_next[randi() % valid_next.size()]
