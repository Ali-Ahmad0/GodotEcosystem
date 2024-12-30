extends Node2D

@onready var stags_group : Node2D = $Stags
@onready var wolfs_group : Node2D = $Wolfs
@onready var debug_display : Control = $CanvasLayer/GlobalStats

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		debug_display.visible = !debug_display.visible
	
	# Display some debug data for the world
	var stags_count : int = stags_group.get_child_count()
	var wolfs_count : int = wolfs_group.get_child_count()
	var total_count : int = stags_count + wolfs_count
	
	# Update text
	debug_display.get_child(0).text = "Total Count: " + str(total_count)
	debug_display.get_child(1).text = "Stags Count: " + str(stags_count)
	debug_display.get_child(2).text = "Wolves Count: " + str(wolfs_count)
