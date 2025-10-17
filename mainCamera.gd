extends Camera2D
var startingpos : Vector2
var startingzoom : Vector2
func _ready():
	startingpos = position
	startingzoom = zoom
func _process(delta: float) -> void:
	position += (startingpos - position) / 10
	zoom += (startingzoom - zoom) / 10


func _on_node_2d_tick_end() -> void:
	position += Vector2(randf()  * 0.1,randf() * 0.1)
	zoom += Vector2(randf()  * 0.1,randf() * 0.1)
