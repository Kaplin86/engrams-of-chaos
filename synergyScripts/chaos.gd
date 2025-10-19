extends BaseSynergy
class_name ChaosSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	pass

var TriggerCount = 0

func get_description(level) -> String:
	TriggerCount += 1
	var desc = randi_range(1,84)
	if desc == 1:
		return "Beings
		 of this
		 grouping
		 are
		
		
		2 Units -
		
		4 Units -
		
		6 Units -"
	else:
		return "Units
		 of this
		 synergy 
		are
		
		
		2 Units -
		
		4 Units -
		
		6 Units -"
	#elif desc == 3:
		#return "Units of this synergy are
		#
		#
		#2 Units -
		#
		#4 Units -
		#
		#6 Units -
		#"
	#elif desc == 4:
		#return "'Where do we come from' asks the toasted one. The chaotic one turned to him 'We exist, so why must we question it?' it asked. 'Im not questioning it. Im questioning YOU, because YOU know.' the toasted one stated. 'We are from the essences of the mind itself, for that is what a engram is', the chaotic one stated calmly. 'What does that make you then, hm?' 'Pure chaos.' "
	#elif desc == 5:
		#return "run"
	return "h"
