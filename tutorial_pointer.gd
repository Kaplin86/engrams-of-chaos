extends CanvasLayer
class_name TutorialPointerObject
var WantedPosition := Vector2(348.0,230.0)
var PointingDirection := deg_to_rad(193.3)
var PointTarget := Vector2(0,0)
var deltatimer = 0

var pointing = false
var flipDir = 1

signal ConfirmPressed

func _process(delta: float) -> void:
	deltatimer += delta
	var BounceY = sin(deltatimer * 3) * 3
	$Guy.global_position -= ($Guy.global_position - WantedPosition + Vector2(0,BounceY)) * 0.1
	
	if pointing:
		if flipDir == -1:
			PointingDirection = WantedPosition.angle_to(WantedPosition - (WantedPosition - PointTarget))
		else:
			PointingDirection = WantedPosition.angle_to(PointTarget)
	else:
		PointingDirection = deg_to_rad(193.3)
	
	$Guy/BurntToastBody/Arm.global_rotation = lerp_angle($Guy/BurntToastBody/Arm.global_rotation,PointingDirection,0.1)
	if Input.is_action_just_pressed("confirm"):
		ConfirmPressed.emit()



func moveTo(newpos : Vector2):
	WantedPosition = newpos

func pointTo(newpos : Vector2):
	PointTarget = newpos

func flip(side):
	flipDir = side
	if side == -1:
		$Guy/BurntToastBody.scale = Vector2(-0.178,0.178)
		$Guy/NinePatchRect.position = Vector2(-239.0,7)
	else:
		$Guy/BurntToastBody.scale = Vector2(0.178,0.178)
		$Guy/NinePatchRect.position = Vector2(73,7)
		

func say(text : String):
	$Guy/NinePatchRect.visible = true
	$Guy/NinePatchRect/RichTextLabel.text = text
	$Guy/NinePatchRect/RichTextLabel.visible_characters = 0
	$Guy/NinePatchRect.size = Vector2i.ZERO
	for E in text.length():
		$Guy/NinePatchRect/RichTextLabel.visible_characters += 1
		$Guy/NinePatchRect.size = Vector2i(175,$Guy/NinePatchRect/RichTextLabel.get_content_height())
		if !Input.is_action_pressed("deny"):
			await get_tree().create_timer(0.05).timeout
	
	await ConfirmPressed
	
	return true

func silent():
	$Guy/NinePatchRect.visible = false
