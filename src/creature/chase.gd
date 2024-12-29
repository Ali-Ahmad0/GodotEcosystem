class_name Chase
extends State

@export var agent : Creature
@export var animator : AnimatedSprite2D
@export var navigation : NavigationAgent2D

var direction : Vector2

func enter() -> void:
	direction = agent.direction
	animate()
	
func update(delta : float) -> void:
	# Navigate to the target
	direction = (navigation.get_next_path_position() - agent.global_position).normalized()
	agent.velocity = direction * agent.speed
	
	animate()
	agent.move_and_slide()
	
	# Target has already been eaten
	if agent.target:
		if agent.target.target_collision.disabled:
			agent.current_state = "idle"
	
	# Exit the state
	if agent.current_state != self.name.to_lower():
		emit_signal("state_transition", self, agent.current_state)

func animate() -> void:
	# Animate the creature
	if direction.x > 0 and direction.y < 0:
		animator.play("run_ne")
		
	if direction.x < 0 and direction.y < 0:
		animator.play("run_nw")
		
	if direction.x > 0 and direction.y > 0:
		animator.play("run_se")
		
	if direction.x < 0 and direction.y > 0:
		animator.play("run_sw")

func leave() -> void:
	# Replenish creature hunger
	agent.hunger += 10
	
func makepath() -> void:
	# Create a path to the target
	if agent.target:
		navigation.target_position = agent.target.global_position

func _on_timer_timeout() -> void:
	# Update the path on every timeout
	makepath()
