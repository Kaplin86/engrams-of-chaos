extends Node2D

@export var Buttons : Array[ColorRect] = []
var buttonHover = 0
var deltatimer = 0

var lastInputDeltatime = 0
signal changeButton

func _process(delta: float) -> void:
	deltatimer += delta
	
	$Logo.scale += (Vector2.ONE - $Logo.scale) / 20
	$FirstEngraMmaintheme.pitch_scale = 1 + (sin(deltatimer * 0.5) * 0.01)
	
	for E in Buttons.size():
		
		var buttonInQuestion = Buttons[E]
		if buttonHover == E:
			if floor(deltatimer * 2) == round(deltatimer * 2):
				buttonInQuestion.color =  Color("b2b2b2")
			else:
				buttonInQuestion.color =  Color("a9a9a9")
			
			$DescBox/ModeName.text = buttonInQuestion.get_child(1).text
			$DescBox/ModeDesc.text = buttonInQuestion.get_meta('desc','Wait this isnt a gamemode.')
		else:
			buttonInQuestion.color = Color("636363")
	
	
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		if deltatimer - lastInputDeltatime > 0.25:
			$Button1.pitch_scale = 1 + ((randf() - 0.5) * 0.1)
		else:
			$Button1.pitch_scale += 0.1
		$Button1.play()
		$Logo.scale += Vector2(0.05,0.05)
		lastInputDeltatime = deltatimer
		
	
	if Input.is_action_just_pressed("ui_up"):
		buttonHover -= 1
		changeButton.emit()
	elif Input.is_action_just_pressed("ui_down"):
		buttonHover += 1
		changeButton.emit()
	
	if Input.is_action_just_pressed("confirm"):
		if buttonHover == 0 or buttonHover == 1 or buttonHover == 2:
			if buttonHover == 0:
				DatastoreHolder.tutorial = true
				DatastoreHolder.enemySynergy = false
				DatastoreHolder.difficulty = "Tutorial"
			if buttonHover == 1:
				DatastoreHolder.enemySynergy = false
				DatastoreHolder.difficulty = "Easy"
			if buttonHover == 2:
				DatastoreHolder.enemySynergy = true
				DatastoreHolder.difficulty = "Normal"
			print("ENEMY SYNERGIES IS " , DatastoreHolder.enemySynergy)
			Transition.TransitionToScene("res://main.tscn")
		elif buttonHover == 3:
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
