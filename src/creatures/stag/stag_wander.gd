class_name StagWander
extends State

@export var agent : Stag
@export var animator : AnimatedSprite2D
@export var navigation : NavigationAgent2D

var prev_direction

func enter() -> void:
	prev_direction = agent.direction
	animate()

func update(delta: float) -> void:
	if prev_direction != agent.direction:
		animate()
		prev_direction = agent.direction
		
	if agent.current_state == "idle":
		emit_signal("state_transition", self, "idle")

	var next_position : Vector2 = agent.global_position + (agent.velocity)
	navigation.target_position = next_position
	
	# If moving outside navigation region
	if not navigation.is_target_reachable():
		# Reverse direction 
		match agent.direction:
			agent.Direction.NE: 
				agent.direction = agent.Direction.SW
			
			agent.Direction.NW: 
				agent.direction = agent.Direction.SE
			
			agent.Direction.SE: 
				agent.direction = agent.Direction.NW
			
			agent.Direction.SW: 
					agent.direction = agent.Direction.NE
					
	agent.move_and_slide()
	
func animate() -> void:
	match agent.direction:
		agent.Direction.NE:
			animator.play("walk_ne")
			
		agent.Direction.NW:
			animator.play("walk_nw")
			
		agent.Direction.SE:
			animator.play("walk_se")
			
		agent.Direction.SW:
			animator.play("walk_sw")
