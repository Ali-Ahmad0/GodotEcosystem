class_name Creature
extends CharacterBody2D

var speed : float = 20

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction : Vector2 = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = direction * speed
	
	move_and_slide()

func create_path(target) -> void:
	navigation_agent.target_position = target.global_position
