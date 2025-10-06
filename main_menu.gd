extends Node2D


func _on_timer_timeout() -> void:
	var newBody : RigidBody2D = $PhysicsBG/RigidBody2D6.duplicate()
	newBody.position = Vector2(randf_range(41.0,678.0),-84.0)
	newBody.freeze = false
	newBody.rotation = randf()
	add_child(newBody)
	
	print("new guy")
