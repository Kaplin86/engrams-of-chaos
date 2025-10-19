extends CanvasLayer
func TransitionToScene(wantedSceneFile : String):
	if DatastoreHolder.Mode == "kitchen":
		$SubViewportContainer/SubViewport/CanvasGroup/Logo.texture = load("res://logo.png")
	else:
		$SubViewportContainer/SubViewport/CanvasGroup/Logo.texture = load("res://cradleLogo.png")
	$AnimationPlayer.play("screen_to_transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(wantedSceneFile)
	$AnimationPlayer.play("transition_to_scene")
