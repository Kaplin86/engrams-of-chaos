extends BaseUnit
class_name BaseRanger
func attackAnim(): ## Plays for the attack animation
	animPlayer.stop()
	animPlayer.speed_scale = 1 / timePerTick
	if Target:
		var theCurve : Curve2D = Curve2D.new()
		theCurve.clear_points()
		theCurve.add_point(Vector2(0,0))
		theCurve.add_point($VisualHolder.to_local(board.map_to_local(Target.board_position)))
		$VisualHolder/Path2D.curve = theCurve
		animPlayer.play("attack")
