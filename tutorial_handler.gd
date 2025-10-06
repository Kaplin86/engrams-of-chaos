extends Node2D
@export var tutorialMode = true
@export var cursorHandler : CursorHandlerObject = null
@export var gameHandler : gameManager = null
func _ready() -> void:
	if !cursorHandler or !gameHandler:
		return
	if !tutorialMode:
		return
	
	# Disable all the player's inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","confirm","deny"]
	# Intro text
	print("Howdy! Im the tutorial guy!")
	print("Welcome to engrams of chaos.")
	print("So you see this pretty START button here. See how its glowing? That means its selected!")
	print("Press Z to START the fight!")
	
	# Allow user to hit the start button
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for user to hit the start button
	await cursorHandler.FightButtonPressed
	# Disable player Inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Wait for the tick to end
	await gameHandler.TickEnd
	# Pause the game
	gameHandler.startButtonHit() # this pauses the game at its current state
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Tick text
	print("Okay so that was a lot in such a short bit of time!")
	print("Engrams of Chaos works with a tick-based system.")
	print("This is the metronome, which shows when ticks happen.")
	print("Every tick, each unit can either move or attack.")
	print("As you can see here, your unit moved.")
	print("Lets resume the fight to see what happens")
	print("Press Z to resume the fight.")
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await gameHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	# Wait for the first attack
	await gameHandler.AttackHit
	# Wait for tick to end
	await gameHandler.TickEnd
	# Pause the game
	gameHandler.startButtonHit()
	
	# Note: Tutorial fight would be constructed so the player's unit gets first hit
	print("Did you see that? Your unit just attacked!")
	print("Since the enemy was in range of your unit, it attacked instead of moving.")
	print("Damage depends on the unit's power and the opponents defense. We will see that soon!")
	print("First, show them whos boss!")
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await gameHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await gameHandler.RoundEnd
	print("What a great battle, you showed them whos boss alright!")
	print("Did you see those circle thingies that appeared on your screen?")
	print("Those are ENGRAMS, which are used for getting more units!")
	print("Press A or D to switch to your CRAFTING button!")
	
	# Allow user to go left or right
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny","confirm"]
	await cursorHandler.CraftingButtonSelected
	# Stop player from moving left or right, but allow them to confirm
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	
	await cursorHandler.CraftingButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Wow! Its dark in here!")
	print("Anyways welcome to the crafting ui.")
	print("You see these two circle slots?")
	print("Select the two ENGRAMS you wanna use using A, D, and Z!")
	
	# Allow player to press left, right, or confirm. S would cause them to go back to the main screen. Deny would cause them to unselect a engram which doesnt matter since they only have 2.
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny"]
	
