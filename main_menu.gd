extends Node2D

@export var Buttons : Array[ColorRect] = []
var buttonHover = 0
var deltatimer = 0

var lastInputDeltatime = 0
signal changeButton

var mode = "kitchen"

var NotGameButtons = ["Additional","CradleOfElements"]

func _process(delta: float) -> void:
	deltatimer += delta
	
	if mode == "kitchen":
		if !Buttons.has($Tutorial):
			Buttons.insert(0,$Tutorial)
	else:
		if Buttons.has($Tutorial):
			Buttons.erase($Tutorial)
	
	$Logo.scale += (Vector2(1.6,1.6) - $Logo.scale) / 20
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
		if Buttons[buttonHover].name not in NotGameButtons:
			DatastoreHolder.enemySynergy = true
			DatastoreHolder.tutorial = false
			if Buttons[buttonHover].name == "Tutorial":
				DatastoreHolder.tutorial = true
				DatastoreHolder.enemySynergy = false
			if Buttons[buttonHover].name == "Easy":
				DatastoreHolder.enemySynergy = false
			
			DatastoreHolder.difficulty = Buttons[buttonHover].name
			DatastoreHolder.Mode = mode
			Transition.TransitionToScene("res://main.tscn")
		elif Buttons[buttonHover].name == "Additional":
			$AdvancedGuide.visible = !$AdvancedGuide.visible
		elif Buttons[buttonHover].name == "CradleOfElements":
			if mode == "kitchen":
				mode = "Cradle"
				buttonHover = 3
				$AnimationPlayer.play("kitchenToCradle")
			else:
				mode = "kitchen"
				$AnimationPlayer.play("cradleToKitchen")
				buttonHover = 4
		
	buttonHover = wrap(buttonHover,0,Buttons.size())

func _on_timer_timeout() -> void:
	var newBody : RigidBody2D = $PhysicsBG/RigidBody2D6.duplicate()
	newBody.position = Vector2(randf_range(41.0,678.0),-84.0)
	newBody.freeze = false
	newBody.rotation = randf()
	var unit = DatastoreHolder.craftingUnitJson.keys().pick_random()
	if load("res://units/"+unit+"/"+unit+".svg"):
		newBody.get_child(0).texture = load("res://units/"+unit+"/"+unit+".svg")
		add_child(newBody)
