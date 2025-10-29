extends Node2D
@export var tutorialMode = true
@export var cursorHandler : CursorHandlerObject = null
@export var gameHandler : gameManager = null
@export var tutorialPointer : TutorialPointerObject = null
func _ready() -> void:
	if !cursorHandler or !gameHandler or !tutorialPointer:
		return
	tutorialMode = DatastoreHolder.tutorial
	if !tutorialMode:
		return
	
	# Disable all the player's inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","confirm","deny"]
	await get_tree().create_timer(1).timeout
	tutorialPointer.moveTo(Vector2(348.0,230.0))
	await get_tree().create_timer(0.5).timeout
	# Intro text
	await tutorialPointer.say("tut1")
	await tutorialPointer.say("tut2")
	await tutorialPointer.say("tut3")
	await tutorialPointer.say("tut4")
	await tutorialPointer.say("tut5")
	await tutorialPointer.say("tut6")
	
	tutorialPointer.moveTo(Vector2(382,293))
	tutorialPointer.pointTo(Vector2(608.0,335))
	tutorialPointer.flip(-1)
	
	await tutorialPointer.say("tut7")
	await tutorialPointer.say("tut8")
	tutorialPointer.silent()
	tutorialPointer.flip(1)
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	
	
	# Allow user to hit the start button
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for user to hit the start button
	await cursorHandler.FightButtonPressed
	# Disable player Inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Wait for the tick to end
	await gameHandler.TickEnd
	await gameHandler.TickEnd
	await gameHandler.TickEnd
	# Pause the game
	gameHandler.startButtonHit() # this pauses the game at its current state
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Tick text
	await tutorialPointer.say("tut8")
	await tutorialPointer.say("tut9")
	
	tutorialPointer.moveTo(Vector2(174,91))
	tutorialPointer.pointTo(Vector2(49.0,50))
	tutorialPointer.pointing = true
	
	await tutorialPointer.say("tut10")
	await tutorialPointer.say("tut11")
	tutorialPointer.moveTo(Vector2(330,258))
	tutorialPointer.pointTo(Vector2(320.0,-20))
	await tutorialPointer.say("tut12")
	
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	await tutorialPointer.say("tut13")
	
	await tutorialPointer.say("tut14")
	tutorialPointer.silent()
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await cursorHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Wait for the first attack
	await gameHandler.AttackHit
	# Wait for tick to end
	await gameHandler.TickEnd
	# Pause the game
	gameHandler.startButtonHit()
	
	# Note: Tutorial fight would be constructed so the player's unit gets first hit
	await get_tree().create_timer(0.2).timeout
	tutorialPointer.moveTo(Vector2(336.195,244))
	tutorialPointer.pointTo(Vector2(218.0,264))
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut15")
	await tutorialPointer.say("tut16")
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	await tutorialPointer.say("tut17")
	tutorialPointer.silent()
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await cursorHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await gameHandler.RoundEnd
	
	# Note: The engrams for the tutorial are RANDOM. You get 3 after the first fight
	await tutorialPointer.say("tut18")
	await tutorialPointer.say("tut19")
	await tutorialPointer.say("tut20")
	await tutorialPointer.say("tut21")
	await tutorialPointer.say("tut22")
	await tutorialPointer.say("tut23")
	await tutorialPointer.say("tut24")
	tutorialPointer.silent()
	
	# Allow user to go left or right
	cursorHandler.disabledInputs = ["ui_up","deny","confirm","ui_left","ui_right"]
	await cursorHandler.CraftingButtonSelected
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(420,396))
	tutorialPointer.pointTo(Vector2(607.0,393))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut25")
	tutorialPointer.silent()
	
	# Stop player from moving left or right, but allow them to confirm
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	
	
	
	await cursorHandler.CraftingButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	tutorialPointer.flip(1)
	await tutorialPointer.say("tut26")
	await tutorialPointer.say("tut27")
	await tutorialPointer.say("tut28")
	await tutorialPointer.say("tut29")
	tutorialPointer.silent()
	
	# Allow player to press left, right, or confirm. S would cause them to go back to the main screen.
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny"]
	await cursorHandler.CraftingAnimFinished
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	await tutorialPointer.say("tut30")
	await tutorialPointer.say("tut31")
	await tutorialPointer.say("tut32")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_right","deny","confirm"]
	await cursorHandler.ReturnFromCrafting
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	await tutorialPointer.say("tut33")
	await tutorialPointer.say("tut34")
	await tutorialPointer.say("tut35")
	await tutorialPointer.say("tut36")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_left","ui_up","ui_right","deny","confirm"]
	await cursorHandler.WentToBoard
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(219.535,291.835))
	tutorialPointer.pointTo(Vector2(136.815,56.955))
	tutorialPointer.pointing = true
	
	await tutorialPointer.say("tut37")
	
	await tutorialPointer.say("tut38")
	
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut39")
	await tutorialPointer.say("tut40")
	await tutorialPointer.say("tut41")
	await tutorialPointer.say("tut42")
	await tutorialPointer.say("tut43")
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	tutorialPointer.flip(1)
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	await cursorHandler.PickUpUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await tutorialPointer.say("tut44")
	await tutorialPointer.say("tut45")
	await tutorialPointer.say("tut46")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = []
	await cursorHandler.DroppedUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut47")
	await tutorialPointer.say("tut48")
	await tutorialPointer.say("tut49")
	tutorialPointer.moveTo(Vector2(526.59,372.41))
	tutorialPointer.flip(1)
	tutorialPointer.pointing = false
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","deny","confirm"]
	await cursorHandler.SynergyView
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(395,325))
	await tutorialPointer.say("tut50")
	tutorialPointer.moveTo(Vector2(181.44,360.125))
	tutorialPointer.pointTo(Vector2(32.49,12.4))
	tutorialPointer.flip(1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut51",cursorHandler.ui.synergyList[cursorHandler.synergyPoint])
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("tut52")
	await tutorialPointer.say("tut53")
	await tutorialPointer.say("tut54")
	await tutorialPointer.say("tut55")
	await tutorialPointer.say("tut56")
	tutorialPointer.moveTo(Vector2(526.59,372.41))
	tutorialPointer.flip(1)
	tutorialPointer.pointing = false
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","deny","confirm"]
	await cursorHandler.ButtonPanelTargeted
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(382,293))
	tutorialPointer.pointTo(Vector2(608.0,335))
	tutorialPointer.pointing = true
	tutorialPointer.flip(-1)
	await tutorialPointer.say("tut57")
	await tutorialPointer.say("tut58")
	await tutorialPointer.say("tut59")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_left","ui_down","ui_right","deny","confirm"]
	await cursorHandler.ButtonPanelTargeted
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(348.0,230.0))
	tutorialPointer.pointing = false
	await tutorialPointer.say("tut60")
	await tutorialPointer.say("tut61")
	await tutorialPointer.say("tut62")
	await tutorialPointer.say("tut63")
	await tutorialPointer.say("tut64")
	tutorialPointer.moveTo(Vector2(348.0,-200))
	tutorialPointer.silent()
	cursorHandler.disabledInputs = []
	
	
	return
	# await gameHandler.superboss
	# secret boss for tutorialmode only since unironically its harder to start in
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	
	tutorialPointer.moveTo(Vector2(348.0,230.0))
	await tutorialPointer.say("Okay champ. So uh. You see that superboss there? It must have detected my presence...")
	await tutorialPointer.say("You see, bosses, or more specifically superbosses, have the engram of 'Chaos'.")
	await tutorialPointer.say("This guy is composed of a SINGLE engram. How thats possible? I dont even know. But it wont stop until it feels full.")
	await tutorialPointer.say("It cant. But hey, you've gotten this far, right? Surely you know how to survive, yes?")
	tutorialPointer.silent()
	await tutorialPointer.slice()
	tutorialPointer.moveTo(Vector2(348.0,300.0))
	await tutorialPointer.say("... dang. Somehow it sliced me. Dont uh. Dont worry champ im fine. Focus on surviving this round. Il be fine.")
	tutorialPointer.moveTo(Vector2(200.0,300))
	await get_tree().create_timer(1)
	tutorialPointer.moveTo(Vector2(-300,300))
	tutorialPointer.silent()
