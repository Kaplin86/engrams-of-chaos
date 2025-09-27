extends BaseUnit
class_name BaseRanger
func attackAnim(): ## Plays for the attack animation
	animPlayer.stop()
	animPlayer.speed_scale = 1 / timePerTick
	if Target:
		var theCurve : Curve2D = $VisualHolder/Path2D.curve
		theCurve.clear_points()
		theCurve.add_point(Vector2(0,0))
		theCurve.add_point(to_local(Target.global_position))
		print(theCurve.get_baked_length())
