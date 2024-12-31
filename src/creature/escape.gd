class_name Escape
extends State

@export var agent : Creature
@export var animator : AnimatedSprite2D
@export var navigation : NavigationAgent2D

var direction : Vector2

func enter() -> void:
	direction = agent.direction
	animate()


func update(delta: float) -> void:
	# Threat no longer exists
	if !agent.threat:
		agent.current_state = "wander"
	
	
	# Exit the state
	if agent.current_state != self.name.to_lower():
		emit_signal("state_transition", self, agent.current_state)
	
	if agent.target:
		direction = (agent.global_position - agent.target.global_position).normalized()
		
	var next_position : Vector2 = agent.global_position + (direction * 48)
	navigation.target_position = next_position

	if navigation.is_target_reachable():
		agent.velocity = direction * agent.speed
	# At a dead end now
	else:
		# Move to any available perpendicular direction
		var perp_direction_1 : Vector2 = Vector2(direction.x, -direction.y)
		var perp_direction_2 : Vector2 = Vector2(-direction.x, direction.y)
		
		# Test the first perpendicular direction
		navigation.target_position = agent.global_position + (perp_direction_1 * 48)
		if navigation.is_target_reachable():
			direction = perp_direction_1
			agent.velocity = perp_direction_1 * agent.speed
		else:
			# Test the second perpendicular direction
			navigation.target_position = agent.global_position + (perp_direction_2 * 48)
			if navigation.is_target_reachable():
				direction = perp_direction_2
				agent.velocity = perp_direction_2 * agent.speed
			else:
				# No valid perpendicular direction
				agent.velocity = Vector2.ZERO 
		
	animate()
	agent.move_and_slide()


func animate() -> void:
	# Animate the creature
	if direction.x > 0 and direction.y < 0:
		animator.play("run_ne")
		
	elif direction.x < 0 and direction.y < 0:
		animator.play("run_nw")
		
	elif direction.x > 0 and direction.y > 0:
		animator.play("run_se")
		
	elif direction.x < 0 and direction.y > 0:
		animator.play("run_sw")
