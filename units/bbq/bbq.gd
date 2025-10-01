extends BaseRanger
func attack(target : BaseUnit, HitCount : int = 1): ## Runs when the unit tries to attack a target
	if HitCount == 0:
		return
	
	target.onHit(damage * (2 * (hp / maxHP)),self, trueDamagePercentage)
	attackAnim(HitCount)
	if maxMana != 0:
		mana += 20
	
	gameManagerObject.unitAttack(self)
	
	if HitCount > 1:
		animPlayer.animation_finished.connect(
			Callable(self, "_on_attack_anim_finished").bind(target, HitCount - 1),CONNECT_ONE_SHOT)
