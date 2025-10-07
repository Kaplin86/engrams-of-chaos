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
	tutorialPointer.moveTo(Vector2(348.0,230.0))
	await get_tree().create_timer(0.5).timeout
	# Intro text
	await tutorialPointer.say("Howdy! Im Burnt Toast! I will be your tutorial fella! Press Z to continue!")
	await tutorialPointer.say("Welcome to Engrams of Chaos.")
	await tutorialPointer.say("So. Goal of the game is simple. Make a team to survive as many battles as possible to beat your highscore.")
	await tutorialPointer.say("When your team dies, your run ends. Simple enough right?")
	await tutorialPointer.say("During battles, your team fights automatically. So, it is your job to prepare them beforehand!")
	await tutorialPointer.say("Lets start the first battle!")
	
	tutorialPointer.moveTo(Vector2(382,293))
	tutorialPointer.pointTo(Vector2(608.0,335))
	tutorialPointer.flip(-1)
	
	await tutorialPointer.say("So you see this pretty START button here. See how its glowing? That means its selected!")
	await tutorialPointer.say("After I stop talking, Press Z to START the fight!")
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
	await tutorialPointer.say("Pause, Pause! Let me explain whats going on a bit.")
	await tutorialPointer.say("Engrams of Chaos works with a tick-based system.")
	
	tutorialPointer.moveTo(Vector2(174,91))
	tutorialPointer.pointTo(Vector2(49.0,50))
	tutorialPointer.pointing = true
	
	await tutorialPointer.say("This is the metronome, which shows when ticks happen.")
	await tutorialPointer.say("Every tick, each unit can either move or attack, they only attack when close to an enemy.")
	tutorialPointer.moveTo(Vector2(330,258))
	tutorialPointer.pointTo(Vector2(320.0,-20))
	await tutorialPointer.say("As you can see here, your unit moved.")
	
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	await tutorialPointer.say("Lets resume the fight to see what happens")
	
	await tutorialPointer.say("Press Z to resume the fight after this message.")
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
	await tutorialPointer.say("Did you see that? Your unit just attacked!")
	await tutorialPointer.say("Since the enemy was in range of your unit, it attacked instead of moving.")
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	await tutorialPointer.say("Now, show them whos boss!")
	tutorialPointer.silent()
	
	# Allow user to hit the start button (Now the unpause button)
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	# Wait for unpause
	await cursorHandler.FightButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await gameHandler.RoundEnd
	
	# Note: The engrams for the tutorial are RANDOM. You get 3 after the first fight
	await tutorialPointer.say("What a great battle, you showed them whos boss alright!")
	await tutorialPointer.say("Did you see those circle thingies that appeared on your screen?")
	await tutorialPointer.say("Those are ENGRAMS, which you get by surviving the round.")
	await tutorialPointer.say("ENGRAMS can be used for CRAFTING new units!!")
	await tutorialPointer.say("You see the loop now, right? You beat up guys, get engrams, make a better team, and repeat?")
	await tutorialPointer.say("Anywhom, lets craft your first unit!")
	await tutorialPointer.say("After this message, Press A or D to switch to your CRAFTING button!")
	tutorialPointer.silent()
	
	# Allow user to go left or right
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny","confirm"]
	await cursorHandler.CraftingButtonSelected
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(420,396))
	tutorialPointer.pointTo(Vector2(607.0,393))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("Now use Z to press the CRAFTING button after this message!")
	tutorialPointer.silent()
	
	# Stop player from moving left or right, but allow them to confirm
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	
	
	
	await cursorHandler.CraftingButtonPressed
	# Disable player inputs
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	tutorialPointer.flip(1)
	await tutorialPointer.say("Wow! Its dark in here!")
	await tutorialPointer.say("Anyways welcome to the crafting ui.")
	await tutorialPointer.say("You see these two circle slots?")
	await tutorialPointer.say("Select the two ENGRAMS you wanna use using A, D, and Z!")
	tutorialPointer.silent()
	
	# Allow player to press left, right, or confirm. S would cause them to go back to the main screen.
	cursorHandler.disabledInputs = ["ui_up","ui_down","deny"]
	await cursorHandler.CraftingAnimFinished
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	await tutorialPointer.say("Wow! What a unique fella you just crafted!")
	await tutorialPointer.say("Let’s head back to the board to see your new ally.")
	await tutorialPointer.say("Press S to go back to the main screen after this!")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_right","deny","confirm"]
	await cursorHandler.ReturnFromCrafting
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	await tutorialPointer.say("You see your unit over there? Now you have a team of a whopping size of 2!")
	await tutorialPointer.say("As you progress through rounds, you will have to expand your team and strategize to survive!")
	await tutorialPointer.say("How about we look at the new unit you made?")
	await tutorialPointer.say("Press S to go to the board!")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_left","ui_up","ui_right","deny","confirm"]
	await cursorHandler.WentToBoard
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(219.535,291.835))
	tutorialPointer.pointTo(Vector2(136.815,56.955))
	tutorialPointer.pointing = true
	
	await tutorialPointer.say("By default, the left-most unit is selected.")
	
	await tutorialPointer.say("You see the unit you just made? They are selected!")
	
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("Their stats are up here in the top right, alongside a description.")
	await tutorialPointer.say("How about we move your unit to a more advantagous position?")
	await tutorialPointer.say("For instance, units with high defense should be in the front to protect the weaker units behind them!")
	await tutorialPointer.say("Smart positioning helps your team survive longer. That’s how you push your score higher!")
	await tutorialPointer.say("Press Z to pick up the selected unit")
	tutorialPointer.moveTo(Vector2(460,90))
	tutorialPointer.pointing = false
	tutorialPointer.flip(1)
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny"]
	await cursorHandler.PickUpUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	await tutorialPointer.say("Wowie!")
	await tutorialPointer.say("You picked up someone without their permission, radical idea.")
	await tutorialPointer.say("Move them around with W, A, S, or D. Once you're done, press Z!")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = []
	await cursorHandler.DroppedUnit
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("Alright. You see those icons in the units info panel? Those are the SYNERGIES your unit has.")
	await tutorialPointer.say("Speaking of synergies, lets go through how you view those!")
	await tutorialPointer.say("Once you are done looking at units, press S")
	tutorialPointer.moveTo(Vector2(526.59,372.41))
	tutorialPointer.flip(1)
	tutorialPointer.pointing = false
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_up","deny","confirm"]
	await cursorHandler.SynergyView
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(395,325))
	await tutorialPointer.say("Welcome to the synergy view!")
	tutorialPointer.moveTo(Vector2(181.44,360.125))
	tutorialPointer.pointTo(Vector2(32.49,12.4))
	tutorialPointer.flip(1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("Right now you have the '" + gameHandler.calculatesynergies(2).keys()[0] + "' synergy selected!")
	tutorialPointer.moveTo(Vector2(397.94,148.765))
	tutorialPointer.pointTo(Vector2(-56.065,-7.695))
	tutorialPointer.flip(-1)
	tutorialPointer.pointing = true
	await tutorialPointer.say("In the top right, you can see what effects it does!")
	await tutorialPointer.say("Synergy effects are based around how many units you have!")
	await tutorialPointer.say("If text is BOLD, that means that effect is ACTIVE!!")
	await tutorialPointer.say("This is also a tool in your strategic toolkit. Effects from synergies will help you last longer!")
	await tutorialPointer.say("Look through your synergies, then press S when your done!")
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
	await tutorialPointer.say("Wait a second, we are back to selecting buttons?!")
	await tutorialPointer.say("Pressing S causes you to go deeper in the ui, so Buttons to Board to Synergies then back to Buttons!")
	await tutorialPointer.say("Pressing W is the opposite! Give it a try")
	tutorialPointer.silent()
	
	cursorHandler.disabledInputs = ["ui_left","ui_down","ui_right","deny","confirm"]
	await cursorHandler.ButtonPanelTargeted
	cursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","deny","confirm"]
	
	tutorialPointer.moveTo(Vector2(348.0,230.0))
	tutorialPointer.pointing = false
	await tutorialPointer.say("Alrighty! Thats EVERYTHING!! You are now given free will great job.")
	await tutorialPointer.say("Remember this saying I always tell myself. Cause chaos to get engrams, then use engrams to do better chaos!")
	await tutorialPointer.say("Whenever you're in doubt, read my automagically changing control guide in the bottom right!")
	await tutorialPointer.say("Just highlight that START button again and press Z when you’re ready for round two!")
	await tutorialPointer.say("Peace!")
	tutorialPointer.moveTo(Vector2(348.0,-200))
	tutorialPointer.silent()
	cursorHandler.disabledInputs = []
