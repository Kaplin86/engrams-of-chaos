extends CanvasLayer
func TransitionToScene(wantedSceneFile : String):
	$AnimationPlayer.play("screen_to_transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(wantedSceneFile)
	$AnimationPlayer.play("transition_to_scene")
