### <ModFile> ###


func slavelist():
	for i in get_node("slavelist/ScrollContainer/VBoxContainer").get_children():
		if i != get_node("slavelist/ScrollContainer/VBoxContainer/line"):
			i.hide()
			i.queue_free()
	for person in globals.slaves:
		if person.away.duration == 0 && !person.sleep in ['farm']:
			var newline = get_node("slavelist/ScrollContainer/VBoxContainer/line").duplicate()
			newline.show()
			get_node("slavelist/ScrollContainer/VBoxContainer").add_child(newline)

			if person.imageportait != null:
				newline.get_node("info/portrait").set_texture(globals.loadimage(person.imageportait))

			var nameNode = newline.get_node("info/namerace/name")
			nameNode.connect("pressed", self, 'openslave', [person])
			nameNode.set_text(person.name_long())
			nameNode.connect("mouse_entered", globals, 'slavetooltip', [person])
			nameNode.connect("mouse_exited", globals, 'slavetooltiphide')
			nameNode.connect('pressed', self, 'openslavetab', [person])

			newline.get_node("info/namerace/race").set_text(person.race)

			newline.get_node("info/grade").set_texture(globals.gradeimages[person.origins])
			newline.get_node("info/grade").connect("mouse_entered", globals, 'gradetooltip', [person])
			newline.get_node("info/grade").connect("mouse_exited", globals, 'hidetooltip')
			newline.get_node("info/spec").set_texture(globals.specimages[str(person.spec)])
			newline.get_node("info/spec").connect("mouse_entered", globals, 'spectooltip', [person])
			newline.get_node("info/spec").connect("mouse_exited", globals, 'hidetooltip')
			newline.get_node("info/movement").set_texture(globals.movementimages[str(globals.expansion.getMovementIcon(person))])
			if person.preg.duration > 0 && person.knowledge.has('currentpregnancy'):
				newline.get_node("info/pregnancy").visible = true
			else:
				newline.get_node("info/pregnancy").texture = null


			newline.get_node("info/stats/strlabel").set_text(str(person.sstr))
			newline.get_node("info/stats/agilabel").set_text(str(person.sagi))
			newline.get_node("info/stats/maflabel").set_text(str(person.smaf))
			newline.get_node("info/stats/endlabel").set_text(str(person.send))
			newline.get_node("info/stats/splabel").set_text(str(person.skillpoints))
			if person.skillpoints > 0:
				newline.get_node("info/stats/splabel").set('custom_colors/font_color', Color(0,1,0))

			newline.get_node("info/stats/courlabel").set_text(str(person.cour))
			newline.get_node("info/stats/conflabel").set_text(str(person.conf))
			newline.get_node("info/stats/witlabel").set_text(str(person.wit))
			newline.get_node("info/stats/charmlabel").set_text(str(person.charm))
			newline.get_node("info/stats/lplabel").set_text(str(person.learningpoints))
			if person.learningpoints > variables.learnpointsperstat:
				newline.get_node("info/stats/lplabel").set('custom_colors/font_color', Color(0,1,0))

			newline.get_node("info/beauty").set_text("B: " + str(person.beauty))


			newline.get_node("info/job").set_text(get_node("MainScreen/slave_tab").jobdict[person.work].name)
			newline.get_node("info/job").connect("pressed",self,'selectjob',[person])
			if person.sleep == 'jail':
				newline.get_node("info/job").set_disabled(true)
			newline.get_node("info/sleep").set_text(globals.sleepdict[person.sleep].name)
			newline.get_node("info/sleep").set_meta("slave", person)
			newline.get_node("info/sleep").connect("pressed", self, 'sleeppressed', [newline.get_node("info/sleep")])
			newline.get_node("info/sleep").connect("item_selected", self, 'sleepselect', [newline.get_node("info/sleep")])
