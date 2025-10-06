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
	print("Did you see that? Your unit just attacked!")
	print("Since the enemy was in range of your unit, it attacked instead of moving.")
	print("Damage depends on the unit's power and the opponents defense. We will see that soon!")
	print("First, show them whos boss!")
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await cursorHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await gameHandler.RoundEnd
	
	# Note: The engrams for the tutorial are RANDOM. You get 3 after the first fight
	print("What a great battle, you showed them whos boss alright!")
	print("Did you see those circle thingies that appeared on your screen?")
	print("Those are ENGRAMS, which are used for getting more units!")
	print("You get them by beating up enemies!")
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
	
	# Allow player to press left, right, or confirm. S would cause them to go back to the main screen.
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny"]
	await cursorHandler.CraftingAnimFinished
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	print("Wow! What a unique fella you just crafted!")
	print("Press S to go back to the main screen!")
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_right","deny","confirm"]
	await cursorHandler.ReturnFromCrafting
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	print("Okay so. This game's ui has 3 main parts. Buttons, board, and synergies.")
	print("Lets select the board to take a look at your units!")
	print("Press S to go to the board!")
	
	cursorHandler.disabledInputs = ["ui_left","ui_up","ui_right","deny","confirm"]
	await cursorHandler.WentToBoard
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	print("By default, the right-most unit is selected.")
	print("You see the unit you just made? They are selected!")
	print("Their stats are up here in the top right, alongside a description.")
	print("How about we move your unit to a more advantagous position?")
	print("Press Z to pick up the selected unit")
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	await cursorHandler.PickUpUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Wowie!")
	print("You picked up someone without their permission, radical idea.")
	print("Move them around with W, A, S, or D. Once your'e done, press Z!")
	
	cursorHandler.disabledInputs = []
	await cursorHandler.DroppedUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Alright. You see those icons in the units info panel? Those are the SYNERGIES your unit has.")
	print("Speaking of synergies, lets go through how you view those!")
	print("Once you are done looking at units, press S")
	
	cursorHandler.disabledInputs = ["ui_up","deny","confirm"]
	await cursorHandler.SynergyView
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Welcome to the synergy view!")
	print("Right now you have the '", gameHandler.calculatesynergies(2).keys()[0], "' synergy selected!")
	print("In the top right, you can see what effects it does!")
	print("Synergy effects are based around how many units you have!")
	print("If text is BOLD, that means that effect is ACTIVE!!")
	print("Look through your synergies, then press S when your done!")
	
	cursorHandler.disabledInputs = ["ui_up","deny","confirm"]
	await cursorHandler.ButtonPanelTargeted
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Wait a second, we are back to selecting buttons?!")
	print("Pressing S causes you to go downwards, so Buttons to Board to Synergies then back to board!")
	print("Pressing W is the opposite! Give it a try")
	
	cursorHandler.disabledInputs = ["ui_left","ui_down","ui_right","deny","confirm"]
	await cursorHandler.ButtonPanelTargeted
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	print("Alrighty! Thats EVERYTHING!! You are now given free will great job.")
	print("Whenever you're in doubt, read my automagically changing control guide in the bottom right!")
	print("Go ahead and start your next battle when your ready!")
	print("Peace!")
	cursorHandler.disabledInputs = []
