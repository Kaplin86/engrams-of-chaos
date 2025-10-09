extends Camera2D
var startingpos : Vector2
func _ready():
	startingpos = position
func _process(delta: float) -> void:
	zoom += (Vector2(2.25,2.25) - zoom) / 10
	position += (startingpos - position) / 10


func _on_node_2d_tick_end() -> void:
	zoom += Vector2(randf()  * 0.1,randf() * 0.1)
	position += Vector2(randf()  * 0.1,randf() * 0.1)
