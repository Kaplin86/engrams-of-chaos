extends ScrollContainer
@export var Main : Node

func _ready():
	await FirebaseConnector.gotTopScores
	loadTopScores()
	

func loadTopScores():
	var difficulty = ""
	if Main.buttonHover == 0:
		difficulty = "Tutorial"
	if Main.buttonHover == 1:
		difficulty = "Easy"
	if Main.buttonHover == 2:
		difficulty = "Normal"
	for E in $VBoxContainer.get_children():
		E.queue_free()
	for E in FirebaseConnector.topscores:
		if E['gamemode'] == difficulty:
			var LabelNew = Label.new()
			LabelNew.custom_minimum_size.x = 175.315
			$VBoxContainer.add_child(LabelNew)
			LabelNew.text = E['name'] + " - " + str(E['score'])

func _on_main_menu_change_button():
	loadTopScores()

func _process(delta):
	$".".scroll_vertical += 1
