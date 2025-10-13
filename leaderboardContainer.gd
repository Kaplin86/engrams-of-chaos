extends ScrollContainer
@export var Main : Node

func _ready():
	LeaderboardAPI.fetch_top()
	await LeaderboardAPI.leaderboard_request_completed
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
	var NewOrdering = []
	if !LeaderboardAPI.lastData:
		return
	for E in LeaderboardAPI.lastData:
		print(LeaderboardAPI.lastData)
		if E['gamemode'] == difficulty:
			NewOrdering.append(E)
	for E in NewOrdering:
		var LabelNew = Label.new()
		LabelNew.custom_minimum_size.x = 175.315
		$VBoxContainer.add_child(LabelNew)
		LabelNew.text = str(NewOrdering.find(E) + 1) + ". " +E['username'] + " - " + str(int(floor(E['score'])))

func _on_main_menu_change_button():
	loadTopScores()

func _process(delta):
	$".".scroll_vertical += 1
