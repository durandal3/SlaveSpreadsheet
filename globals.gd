### <ModFile> ###

func spectooltip(person):
	var text
	if person.spec == null:
		text = "Specialization can provide special abilities and effects and can be trained at Slavers' Guild. "
	else:
		var spec = globals.jobs.specs[person.spec]
		text = "[center]" + spec.name + '[/center]\n'+ spec.descript + "\n[color=aqua]" +  spec.descriptbonus + '[/color]'
	globals.showtooltip(text)
