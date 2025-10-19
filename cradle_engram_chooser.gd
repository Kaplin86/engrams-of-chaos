extends Node2D

var loadout : Array[String] = []
@export var machines : Array[Node] = []

var selectedButton = "confirm"
var canSelect = false
var deltatimer = 0
func _ready():
	await get_tree().create_timer(1).timeout
	spin()
func spin():
	canSelect = false
	var theTexture = Image.new()
	var NewEngrams = DatastoreHolder.CradleEngrams.duplicate()
	loadout = []
	for E in range(6):
		var Chosen = NewEngrams.pick_random()
		NewEngrams.erase(Chosen)
		loadout.append(Chosen)
	print(machines)
	for E in machines:
		print(E)
		E.target = loadout[machines.find(E)]
		E.startSpin()
	
	
	DatastoreHolder.SelectedCradleEngrams = loadout
	await $Machine1.stop
	canSelect = true
	
	
func _process(delta):
	deltatimer += delta
	if canSelect:
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			if selectedButton == "confirm":
				selectedButton = "reroll"
			else:
				selectedButton = "confirm"
		
		if selectedButton == "confirm":
			if floor(deltatimer * 2) == round(deltatimer * 2):
				$confirm.color =  Color("b2b2b2")
			else:
				$confirm.color =  Color("a9a9a9")
			
			$reroll.color = Color("636363")
		else:
			if floor(deltatimer * 2) == round(deltatimer * 2):
				$reroll.color =  Color("b2b2b2")
			else:
				$reroll.color =  Color("a9a9a9")
			
			$confirm.color = Color("636363")
		$confirm.modulate = Color(1,1,1)
		$reroll.modulate = Color(1,1,1)
		
		if Input.is_action_just_pressed("confirm"):
			if selectedButton == "confirm":
				Transition.TransitionToScene("res://main.tscn")
			else:
				spin()
		
		
	else:
		$confirm.modulate = Color(0,0,0)
		$reroll.modulate = Color(0,0,0)
