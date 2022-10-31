### <ModFile> ###

var slavelist_expansionenabled = "expansion" in globals
var slavelistinstance = load("res://files/slavelist.tscn")
var slavelist_sortarray = []
var slavelist_movementorder = ['fly', 'walk', 'crawl', 'none']

var slavelist_pregnantimage = null
if slavelist_expansionenabled:
	slavelist_pregnantimage = load("res://files/aric_expansion_images/pregnancy_icons/pregnancy_icon.png")

func slavelist():
	for i in get_node("slavelist").get_children():
		i.hide()
		i.queue_free()

	var node = slavelistinstance.instance()
	get_node("slavelist").add_child(node)
	node.get_node("listclose").connect("pressed", self, '_on_listclose_pressed')


	var sortNode = node.get_node("sortline")
	sortNode.get_node("name").connect("pressed", self, 'slavelist_update_sort_array', ['name'])
	sortNode.get_node("name").set_pressed('name' in slavelist_sortarray)
	sortNode.get_node("race").connect("pressed", self, 'slavelist_update_sort_array', ['race'])
	sortNode.get_node("race").set_pressed('race' in slavelist_sortarray)
	sortNode.get_node("beauty").connect("pressed", self, 'slavelist_update_sort_array', ['beauty'])
	sortNode.get_node("beauty").set_pressed('beauty' in slavelist_sortarray)
	sortNode.get_node("sex").connect("pressed", self, 'slavelist_update_sort_array', ['sex'])
	sortNode.get_node("sex").set_pressed('sex' in slavelist_sortarray)
	sortNode.get_node("grade").connect("pressed", self, 'slavelist_update_sort_array', ['grade'])
	sortNode.get_node("grade").set_pressed('grade' in slavelist_sortarray)
	sortNode.get_node("specialization").connect("pressed", self, 'slavelist_update_sort_array', ['specialization'])
	sortNode.get_node("specialization").set_pressed('specialization' in slavelist_sortarray)
	sortNode.get_node("movement").connect("pressed", self, 'slavelist_update_sort_array', ['movement'])
	sortNode.get_node("movement").set_pressed('movement' in slavelist_sortarray)
	sortNode.get_node("pregnant").connect("pressed", self, 'slavelist_update_sort_array', ['pregnant'])
	sortNode.get_node("pregnant").set_pressed('pregnant' in slavelist_sortarray)
	sortNode.get_node("str").connect("pressed", self, 'slavelist_update_sort_array', ['str'])
	sortNode.get_node("str").set_pressed('str' in slavelist_sortarray)
	sortNode.get_node("agi").connect("pressed", self, 'slavelist_update_sort_array', ['agi'])
	sortNode.get_node("agi").set_pressed('agi' in slavelist_sortarray)
	sortNode.get_node("maf").connect("pressed", self, 'slavelist_update_sort_array', ['maf'])
	sortNode.get_node("maf").set_pressed('maf' in slavelist_sortarray)
	sortNode.get_node("end").connect("pressed", self, 'slavelist_update_sort_array', ['end'])
	sortNode.get_node("end").set_pressed('end' in slavelist_sortarray)
	sortNode.get_node("ap").connect("pressed", self, 'slavelist_update_sort_array', ['ap'])
	sortNode.get_node("ap").set_pressed('ap' in slavelist_sortarray)
	sortNode.get_node("cour").connect("pressed", self, 'slavelist_update_sort_array', ['cour'])
	sortNode.get_node("cour").set_pressed('cour' in slavelist_sortarray)
	sortNode.get_node("conf").connect("pressed", self, 'slavelist_update_sort_array', ['conf'])
	sortNode.get_node("conf").set_pressed('conf' in slavelist_sortarray)
	sortNode.get_node("wit").connect("pressed", self, 'slavelist_update_sort_array', ['wit'])
	sortNode.get_node("wit").set_pressed('wit' in slavelist_sortarray)
	sortNode.get_node("charm").connect("pressed", self, 'slavelist_update_sort_array', ['charm'])
	sortNode.get_node("charm").set_pressed('charm' in slavelist_sortarray)
	sortNode.get_node("lp").connect("pressed", self, 'slavelist_update_sort_array', ['lp'])
	sortNode.get_node("lp").set_pressed('lp' in slavelist_sortarray)
	sortNode.get_node("job").connect("pressed", self, 'slavelist_update_sort_array', ['job'])
	sortNode.get_node("job").set_pressed('job' in slavelist_sortarray)
	sortNode.get_node("sleep").connect("pressed", self, 'slavelist_update_sort_array', ['sleep'])
	sortNode.get_node("sleep").set_pressed('sleep' in slavelist_sortarray)


	sortNode.get_node("reset").connect("pressed", self, 'slavelist_reset_sort_array')

	if slavelist_expansionenabled:
		sortNode.get_node("movement").set_button_icon(globals.movementimages['woman_walk_clothed'])
		sortNode.get_node("pregnant").set_button_icon(slavelist_pregnantimage)
	else:
		sortNode.get_node("movement").hide()
		sortNode.get_node("pregnant").hide()



	var sortLabel = node.get_node("sortingfields")
	var sortstr = str(slavelist_sortarray) # substr to cut of the "[]"
	sortLabel.set_text("Sorting on: " + sortstr.substr(1, sortstr.length() - 2))

	var sortedList = []
	for person in globals.slaves:
		sortedList.append(person)

	sortedList.sort_custom(self, 'slavelist_sort')


	for person in sortedList:
		if person.away.duration == 0 && !person.sleep in ['farm']:
			var newline = node.get_node("ScrollContainer/VBoxContainer/line").duplicate()
			newline.show()
			node.get_node("ScrollContainer/VBoxContainer").add_child(newline)

			if person.imageportait != null:
				newline.get_node("info/portrait").set_texture(globals.loadimage(person.imageportait))

			var nameNode = newline.get_node("info/namerace/name")
			nameNode.connect("pressed", self, 'openslave', [person])
			nameNode.set_text(person.name_long())
			nameNode.connect("mouse_entered", globals, 'slavetooltip', [person])
			nameNode.connect("mouse_exited", globals, 'slavetooltiphide')
			nameNode.connect('pressed', self, 'openslavetab', [person])
			newline.get_node("info/portrait").connect("mouse_entered", globals, 'slavetooltip', [person])
			newline.get_node("info/portrait").connect("mouse_exited", globals, 'slavetooltiphide')

			newline.get_node("info/namerace/race").set_text(person.race)

			globals.description.person = person
			newline.get_node("info/namerace/beauty").set_text(globals.description.getbeauty(true).capitalize() + " (" + str(person.beauty) + ")")


			newline.get_node("info/sex").texture = globals.sexicon[person.sex]
			newline.get_node("info/grade").set_texture(globals.gradeimages[person.origins])
			newline.get_node("info/grade").connect("mouse_entered", globals, 'gradetooltip', [person])
			newline.get_node("info/grade").connect("mouse_exited", globals, 'hidetooltip')
			newline.get_node("info/spec").set_texture(globals.specimages[str(person.spec)])
			newline.get_node("info/spec").connect("mouse_entered", globals, 'spectooltip', [person])
			newline.get_node("info/spec").connect("mouse_exited", globals, 'hidetooltip')
			if slavelist_expansionenabled:
				newline.get_node("info/movement").set_texture(globals.movementimages[str(globals.expansion.getMovementIcon(person))])
				newline.get_node("info/movement").connect("mouse_entered", self, '_on_movement_mouse_entered', [person])
				newline.get_node("info/movement").connect("mouse_exited", self, '_on_movement_mouse_exited')

				if person.preg.duration > 0 && person.knowledge.has('currentpregnancy'):
					newline.get_node("info/pregnancy").set_texture(slavelist_pregnantimage)
				else:
					newline.get_node("info/pregnancy").texture = null
			else:
				newline.get_node("info/pregnancy").hide()
				newline.get_node("info/movement").hide()


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
			if person.learningpoints >= variables.learnpointsperstat:
				newline.get_node("info/stats/lplabel").set('custom_colors/font_color', Color(0,1,0))


			newline.get_node("info/job").set_text(globals.jobs.jobdict[person.work].name)
			newline.get_node("info/job").connect("pressed",self,'selectjob',[person])
			if person.sleep == 'jail':
				newline.get_node("info/job").set_disabled(true)
			newline.get_node("info/sleep").set_text(globals.sleepdict[person.sleep].name)
			newline.get_node("info/sleep").set_meta("slave", person)
			newline.get_node("info/sleep").connect("pressed", self, 'sleeppressed', [newline.get_node("info/sleep")])
			newline.get_node("info/sleep").connect("item_selected", self, 'sleepselect', [newline.get_node("info/sleep")])

func slavelist_update_sort_array(field):
	var i = slavelist_sortarray.find(field)
	if i >= 0:
		slavelist_sortarray.remove(i)
	else:
		slavelist_sortarray.append(field)
	slavelist()

func slavelist_reset_sort_array():
	slavelist_sortarray.clear()
	slavelist()

func slavelist_sort(first, second):
	for field in slavelist_sortarray:
		match field:
			"name":
				if first.name != second.name:
					return first.name <= second.name
			"race":
				if first.race != second.race:
					return first.race <= second.race
			"beauty":
				if first.beauty != second.beauty:
					return first.beauty >= second.beauty
			"sex":
				if first.sex != second.sex:
					return first.sex <= second.sex
			"grade":
				var firstorigin = globals.originsarray.find(first.origins)
				var secondorigin = globals.originsarray.find(second.origins)
				if firstorigin != secondorigin:
					return firstorigin >= secondorigin
			"specialization":
				if first.spec != second.spec:
					if first.spec == null:
						return false
					if second.spec == null:
						return true
					return first.spec <= second.spec
			"movement":
				var firstmove = slavelist_movementorder.find(first.movement)
				var secondmove = slavelist_movementorder.find(second.movement)
				if firstmove != secondmove:
					return firstmove <= secondmove
			"pregnant":
				var firstpreg = first.preg.duration > 0 && first.knowledge.has('currentpregnancy')
				var secondpreg = second.preg.duration > 0 && second.knowledge.has('currentpregnancy')
				if firstpreg != secondpreg:
					return firstpreg
			"str":
				if first.sstr != second.sstr:
					return first.sstr >= second.sstr
			"agi":
				if first.sagi != second.sagi:
					return first.sagi >= second.sagi
			"maf":
				if first.smaf != second.smaf:
					return first.smaf >= second.smaf
			"end":
				if first.send != second.send:
					return first.send >= second.send
			"ap":
				if first.skillpoints != second.skillpoints:
					return first.skillpoints >= second.skillpoints
			"cour":
				if first.cour != second.cour:
					return first.cour >= second.cour
			"conf":
				if first.conf != second.conf:
					return first.conf >= second.conf
			"wit":
				if first.wit != second.wit:
					return first.wit >= second.wit
			"charm":
				if first.charm != second.charm:
					return first.charm >= second.charm
			"lp":
				if first.learningpoints != second.learningpoints:
					return first.learningpoints >= second.learningpoints
			"job":
				if first.work != second.work:
					return globals.jobs.jobdict.keys().find(first.work) <= globals.jobs.jobdict.keys().find(second.work)
			"sleep":
				if first.sleep != second.sleep:
					if first.sleep == 'jail':
						return false
					if second.sleep == 'jail':
						return true
					return globals.sleepdict.keys().find(first.sleep) <= globals.sleepdict.keys().find(second.sleep)
	return globals.slaves.find(first) <= globals.slaves.find(second) # keep the sort stable


# Copied from expansion
func _on_movement_mouse_entered(person):
	var text
	if person.movement == 'walk':
		text = "[center][color=aqua]Normal Movement.[/color][/center]\n$name is walking around like normal."
	elif person.movement == 'fly':
		text = "[center][color=aqua]Will Fly until under 50 Energy[/color][/center]\n$name is currently flapping $his wings and hovering a foot or two off of the ground.\n\n[color=green]Attack and Speed increased by 125%\n[/color]"
	elif person.movement == 'crawl':
		text = "[center][color=red]Only able to Crawl.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently crawling on the ground on all fours.\n\n"
	elif person.movement == 'none':
		text = "[center][color=red]Unable to Move.\nAttack and Speed Penalties in Combat.\nWill not Join the Party.\nUnable to work many jobs.[/color][/center]\n$name is currently unable to move at all. $He is currently completely incapacitated."
	else:
		text = "[center][color=red]Error[/color][/center]\n$name is somehow moving in an unnatural way. While interesting, you may want to report this to Aric on the itch.io forums or Discord. "

	#Give Reason for Crawling/Immobilized
	text += "\n\nReason for Movement: " + PoolStringArray(person.movementreasons).join("\n")

	globals.showtooltip( person.dictionary(text))

func _on_movement_mouse_exited():
	globals.hidetooltip()