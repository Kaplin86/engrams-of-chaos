extends Node

const FIREBASE_PROJECT_ID = "engrams-of-chaos-web-leadboard" 
const FIREBASE_API_KEY = "AIzaSyC-W-dSPlx8XY1K-zD3owoPKaEJGU4HZIA"
const FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/%s/databases/(default)/documents/leaderboard" % FIREBASE_PROJECT_ID

@onready var http := HTTPRequest.new()
var topscores = []

signal gotTopScores

func _ready():
	add_child(http)
	#get_top_scores()

func post_score(name: String, score: int, gamemode : String, mainSynergy : String):
	var url = FIRESTORE_URL + "?key=" + FIREBASE_API_KEY
	var data = {
		"fields": {
			"name": {"stringValue": name},
			"score": {"integerValue": str(score)},
			"gamemode": {"stringValue": gamemode},
			"main synergy": {"stringValue":mainSynergy}
		}
	}
	var body = JSON.stringify(data)
	http.request(url, [], HTTPClient.METHOD_POST, body)
	print("Posted score:", name, score)

func get_top_scores():
	var url = FIRESTORE_URL + "?key=" + FIREBASE_API_KEY
	http.request(url, [], HTTPClient.METHOD_GET)
	http.connect("request_completed", Callable(self, "_on_request_completed"))

func _on_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	if typeof(response) == TYPE_DICTIONARY and response.has("documents"):
		var docs = response["documents"]
		var scores = []
		for d in docs:
			var f = d["fields"]
			scores.append({
				"name": f["name"]["stringValue"],
				"score": int(f["score"]["integerValue"]),
				"gamemode": f["gamemode"]["stringValue"],
				"main synergy": f["gamemode"]["stringValue"]
			})
		# Sort descending by score
		scores.sort_custom(func(a, b): return a["score"] > b["score"] )
		topscores = scores
		gotTopScores.emit()
