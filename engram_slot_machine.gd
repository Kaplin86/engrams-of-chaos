extends Node2D

var engramNameToTexture = {}
var CurrentList = []
var engramNameToColor = {}
var target = "spicy"

func _ready():
	for E in DatastoreHolder.CradleEngrams:
		engramNameToTexture[E] = load("res://ui/elements/"+E+".svg")
		engramNameToColor[E] = getColorOfImage(engramNameToTexture[E])
	
	CurrentList.append(DatastoreHolder.CradleEngrams.pick_random())
	CurrentList.append(DatastoreHolder.CradleEngrams.pick_random())
	CurrentList.append(DatastoreHolder.CradleEngrams.pick_random())
	CurrentList.append(DatastoreHolder.CradleEngrams.pick_random())
	
	startSpin()

func getColorOfImage(texture : Texture2D):
	var color := Vector3.ZERO
	var texture_size := texture.get_size()
	var image := texture.get_image()
	
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			var pixel := image.get_pixel(x, y)
			if pixel.r + pixel.g + pixel.b != 0:
				color += Vector3(pixel.r, pixel.g, pixel.b)
			
			
	color /= texture_size.x * texture_size.y

	return Color(color.x, color.y, color.z)


func startSpin():
	target = "spicy"
	VisualizeCurrentList()
	$AnimationPlayer.play("scroll")
	var NewTween = get_tree().create_tween()
	NewTween.tween_property($AnimationPlayer,"speed_scale",24,2)
	await get_tree().create_timer(4).timeout
	NewTween = get_tree().create_tween()
	NewTween.tween_property($AnimationPlayer,"speed_scale",1,4)



func switchEngrams():
	if $AnimationPlayer.speed_scale <= 7:
		CurrentList.pop_front()
		CurrentList.append(target)
	else:
		CurrentList.pop_front()
		CurrentList.append(DatastoreHolder.CradleEngrams.pick_random())
	
	VisualizeCurrentList()
	
	
	

func VisualizeCurrentList(restartAnim = false):
	$ItemList/Offset/Holder/BeforeStart.texture = engramNameToTexture[CurrentList[0]]
	$ItemList/Offset/Holder/Start.texture = engramNameToTexture[CurrentList[1]]
	$ItemList/Offset/Holder/End.texture = engramNameToTexture[CurrentList[2]]
	$ItemList/Offset/Holder/AfterEnd.texture = engramNameToTexture[CurrentList[3]]
	
	var NewTween = get_tree().create_tween()
	NewTween.tween_property($Slot,"modulate",engramNameToColor[CurrentList[2]],0.1)
	
	$Selected.text = CurrentList[2]
	
	if $AnimationPlayer.speed_scale <= 1:
		$AnimationPlayer.stop()
		NewTween = get_tree().create_tween()
		NewTween.tween_property($Slot,"modulate",engramNameToColor[CurrentList[1]],0.1)
