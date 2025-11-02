extends Node2D

@export var Buttons : Array[ColorRect] = []
@export var ExtraButtons : Array[ColorRect] = []
var currentButtons
var buttonHover = 0
var deltatimer = 0

var lastInputDeltatime = 0
signal changeButton

var mode = "kitchen"
var showingExtra = false

var NotGameButtons = ["Additional","CradleOfElements","EXTRA","Back"]
var pressed = false

func _process(delta: float) -> void:
	deltatimer += delta
	if !showingExtra:
		currentButtons = Buttons
	else:
		currentButtons = ExtraButtons
	
	if Input.is_key_pressed(KEY_J):
		if pressed == false:
			pressed = true
			if TranslationServer.get_locale() == "en":
				TranslationServer.set_locale("ja")
			else:
				TranslationServer.set_locale("en")
	else:
		pressed = false
	
	if mode == "kitchen":
		if !Buttons.has($Base/Tutorial):
			Buttons.insert(0,$Base/Tutorial)
	else:
		if Buttons.has($Base/Tutorial):
			Buttons.erase($Base/Tutorial)
	
	$Logo.scale += (Vector2(1.6,1.6) - $Logo.scale) / 20
	$FirstEngraMmaintheme.pitch_scale = 1 + (sin(deltatimer * 0.5) * 0.01)
	
	for E in currentButtons.size():
		
		var buttonInQuestion = currentButtons[E]
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
		if currentButtons[buttonHover].name not in NotGameButtons:
			DatastoreHolder.enemySynergy = true
			DatastoreHolder.tutorial = false
			if currentButtons[buttonHover].name == "Tutorial":
				DatastoreHolder.tutorial = true
				DatastoreHolder.enemySynergy = false
			if currentButtons[buttonHover].name == "Easy":
				DatastoreHolder.enemySynergy = false
			
			DatastoreHolder.difficulty = currentButtons[buttonHover].name
			DatastoreHolder.Mode = mode
			if mode == "kitchen":
				Transition.TransitionToScene("res://main.tscn")
			else:
				Transition.TransitionToScene("res://cradleEngramChooser.tscn")
		elif currentButtons[buttonHover].name == "Additional":
			$AdvancedGuide.visible = !$AdvancedGuide.visible
		elif currentButtons[buttonHover].name == "EXTRA":
			showingExtra = true
			buttonHover = 0
			$AnimationPlayer.play("normal_to_extra")
		elif currentButtons[buttonHover].name == "Back":
			showingExtra = false
			buttonHover = 0
			$AnimationPlayer.play("normal_to_extra",-1,-1,true)
			
		elif currentButtons[buttonHover].name == "CradleOfElements":
			if mode == "kitchen":
				mode = "Cradle"
				buttonHover = 3
				$AnimationPlayer.play("kitchenToCradle")
			else:
				mode = "kitchen"
				$AnimationPlayer.play("cradleToKitchen")
				buttonHover = 4
		
	buttonHover = wrap(buttonHover,0,currentButtons.size())

func _on_timer_timeout() -> void:
	var newBody : RigidBody2D = $PhysicsBG/RigidBody2D6.duplicate()
	newBody.position = Vector2(randf_range(41.0,678.0),-84.0)
	newBody.freeze = false
	newBody.rotation = randf()
	var unit
	if mode == "kitchen":
		unit = DatastoreHolder.getFusedUnit(["spicy","sweet","salty","bitter","sour","umami"].pick_random(),["spicy","sweet","salty","bitter","sour","umami"].pick_random())
	else:
		unit = DatastoreHolder.craftingUnitJson.keys().pick_random()
	
	if load("res://units/"+unit+"/"+unit+".svg"):
		newBody.get_child(0).texture = load("res://units/"+unit+"/"+unit+".svg")
		add_child(newBody)
