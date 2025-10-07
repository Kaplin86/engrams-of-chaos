extends Node2D

@export var Buttons : Array[ColorRect] = []
var buttonHover = 0
var deltatimer = 0
func _process(delta: float) -> void:
	deltatimer += delta
	for E in Buttons.size():
		
		var buttonInQuestion = Buttons[E]
		if buttonHover == E:
			if floor(deltatimer * 2) == round(deltatimer * 2):
				buttonInQuestion.color =  Color("b2b2b2")
			else:
				buttonInQuestion.color =  Color("a9a9a9")
		else:
			buttonInQuestion.color = Color("636363")
	
	if Input.is_action_just_pressed("ui_up"):
		buttonHover -= 1
	elif Input.is_action_just_pressed("ui_down"):
		buttonHover += 1
	
	if Input.is_action_just_pressed("confirm"):
		if buttonHover == 0 or buttonHover == 1:
			if buttonHover == 0:
				DatastoreHolder.tutorial = true
			get_tree().change_scene_to_file("res://main.tscn")
		elif buttonHover == 2:
			$AdvancedGuide.visible = !$AdvancedGuide.visible
		
	buttonHover = wrap(buttonHover,0,Buttons.size())

func _on_timer_timeout() -> void:
	var newBody : RigidBody2D = $PhysicsBG/RigidBody2D6.duplicate()
	newBody.position = Vector2(randf_range(41.0,678.0),-84.0)
	newBody.freeze = false
	newBody.rotation = randf()
	var unit = DatastoreHolder.craftingUnitJson.keys().pick_random()
	newBody.get_child(0).texture = load("res://units/"+unit+"/"+unit+".svg")
	add_child(newBody)
	
	print("new guy")
