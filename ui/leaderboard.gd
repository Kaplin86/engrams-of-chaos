extends Node2D
var LetterSelect = 1
var deltatimer = 0
var letterArray = [" ","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","!","?",".","+","-","*","/",":","_","(",")"]
var saved = false

var censoredWords = ["ASS","CUM","FUC","FUK","KYS","COK","KOK","COC","DIK","DIC"] # be a coolkid and dont say naughty words please

func _process(delta):
	deltatimer += delta
	var letterObjectSelected : Label = get_node("Control/Letter" + str(LetterSelect))
	for E in $Control.get_children():
		E.modulate = Color(1,1,1,1)
	letterObjectSelected.modulate = Color(0.7,1,1,0.75 + (sin(deltatimer * 15) * 0.25))
	if Input.is_action_just_pressed("ui_up"):
		letterObjectSelected.text = letterArray[wrap(letterArray.find(letterObjectSelected.text) + 1,0,letterArray.size())]
		$Move2.play()
		if $Control/Letter1.text + $Control/Letter2.text + $Control/Letter3.text in censoredWords:
			letterObjectSelected.text = letterArray[wrap(letterArray.find(letterObjectSelected.text) + 1,0,letterArray.size())]
	if Input.is_action_just_pressed("ui_down"):
		letterObjectSelected.text = letterArray[wrap(letterArray.find(letterObjectSelected.text) - 1,0,letterArray.size())]
		$Move2.play()
		if $Control/Letter1.text + $Control/Letter2.text + $Control/Letter3.text in censoredWords:
			letterObjectSelected.text = letterArray[wrap(letterArray.find(letterObjectSelected.text) - 1,0,letterArray.size())]
	if Input.is_action_just_pressed("ui_right"):
		LetterSelect += 1
		
		$Move.play()
	elif Input.is_action_just_pressed("ui_left"):
		LetterSelect -= 1
		$Move.play()
	LetterSelect = wrap(LetterSelect,1,4)
	if !saved:
		if Input.is_action_just_pressed("confirm"):
			saved = true
			print(",".join(DatastoreHolder.UnitTypesUsed))
			if DatastoreHolder.Mode == "Cradle":
				LeaderboardAPI.submit_score($Control/Letter1.text + $Control/Letter2.text + $Control/Letter3.text,DatastoreHolder.waveOfDeath,"Cradle" + DatastoreHolder.difficulty,DatastoreHolder.highestSynergy,",".join(DatastoreHolder.UnitTypesUsed) )
			else:
				LeaderboardAPI.submit_score($Control/Letter1.text + $Control/Letter2.text + $Control/Letter3.text,DatastoreHolder.waveOfDeath,DatastoreHolder.difficulty,DatastoreHolder.highestSynergy,",".join(DatastoreHolder.UnitTypesUsed) )


			Transition.TransitionToScene("res://main_menu.tscn")
		if Input.is_action_just_pressed("deny"):
			saved = true
			Transition.TransitionToScene("res://main_menu.tscn")
