
### <CustomFile> ###

var settings = load(globals.modfolder + "/SlaveSpreadsheet/settings.gd").new()

var base_node = null
var mansion = null

var expansion_enabled = "expansion" in globals
var slavelist_node = load(globals.modfolder + "/SlaveSpreadsheet/slavelist.tscn").instance()
var slavelist_line_node = load(globals.modfolder + "/SlaveSpreadsheet/listline.tscn")
var custom_field = slavelist_node.get_node("customfieldline/field")
var custom_combo = slavelist_node.get_node("customfieldline/combo")
var trait_combo = slavelist_node.get_node("sortingfilterline/traitfiltercombo")
var mainsion_filter = slavelist_node.get_node("sortingfilterline/mansionfilter")
var jail_filter = slavelist_node.get_node("sortingfilterline/jailfilter")
var farm_filter = slavelist_node.get_node("sortingfilterline/farmfilter")
var away_filter = slavelist_node.get_node("sortingfilterline/awayfilter")
var sort_array = []
var movement_order = ['fly', 'walk', 'crawl', 'none']

var pregnant_image = null if not expansion_enabled else load("res://files/aric_expansion_images/pregnancy_icons/pregnancy_icon.png")


func init(mansion_node: Node, popup_node: Node):
	mansion = mansion_node
	# Remove original contents
	base_node = popup_node
	for i in base_node.get_children():
		i.hide()
		i.queue_free()

	base_node.add_child(slavelist_node)
	# Set up static elements - sort buttons, close button
	slavelist_node.get_node("buttonline/listclose").connect("pressed", mansion, '_on_listclose_pressed')
	slavelist_node.get_node("buttonline/sexbuttons/startsex").connect("pressed", self, 'startsexpressed')
	slavelist_node.get_node("buttonline/sexbuttons/clearsex").connect("pressed", self, 'clearsexpressed')

	var sortNode = slavelist_node.get_node("sortline")
	sortNode.get_node("name").connect("pressed", self, 'update_sort_array', ['name'])
	sortNode.get_node("race").connect("pressed", self, 'update_sort_array', ['race'])
	sortNode.get_node("beauty").connect("pressed", self, 'update_sort_array', ['beauty'])
	sortNode.get_node("sex").connect("pressed", self, 'update_sort_array', ['sex'])
	sortNode.get_node("grade").connect("pressed", self, 'update_sort_array', ['grade'])
	sortNode.get_node("specialization").connect("pressed", self, 'update_sort_array', ['specialization'])
	sortNode.get_node("movement").connect("pressed", self, 'update_sort_array', ['movement'])
	sortNode.get_node("pregnant").connect("pressed", self, 'update_sort_array', ['pregnant'])
	sortNode.get_node("str").connect("pressed", self, 'update_sort_array', ['str'])
	sortNode.get_node("agi").connect("pressed", self, 'update_sort_array', ['agi'])
	sortNode.get_node("maf").connect("pressed", self, 'update_sort_array', ['maf'])
	sortNode.get_node("end").connect("pressed", self, 'update_sort_array', ['end'])
	sortNode.get_node("ap").connect("pressed", self, 'update_sort_array', ['attr. points'])
	sortNode.get_node("cour").connect("pressed", self, 'update_sort_array', ['cour'])
	sortNode.get_node("conf").connect("pressed", self, 'update_sort_array', ['conf'])
	sortNode.get_node("wit").connect("pressed", self, 'update_sort_array', ['wit'])
	sortNode.get_node("charm").connect("pressed", self, 'update_sort_array', ['charm'])
	sortNode.get_node("lp").connect("pressed", self, 'update_sort_array', ['learn points'])
	sortNode.get_node("custom").connect("pressed", self, 'update_sort_array', ['custom'])
	sortNode.get_node("job").connect("pressed", self, 'update_sort_array', ['job'])
	sortNode.get_node("sleep").connect("pressed", self, 'update_sort_array', ['sleep'])

	sortNode.get_node("reset").connect("pressed", self, 'reset_sort_array')

	trait_combo.connect("item_selected", self, 'on_trait_combo_select')

	if !settings.show_location_filters:
		slavelist_node.get_node("sortingfilterline/filterlocationlabel").hide()
		mainsion_filter.hide()
		jail_filter.hide()
		farm_filter.hide()
		away_filter.hide()

	mainsion_filter.set_pressed(settings.default_mansion_visible)
	jail_filter.set_pressed(settings.default_jail_visible)
	farm_filter.set_pressed(settings.default_farm_visible)
	away_filter.set_pressed(settings.default_away_visible)

	mainsion_filter.connect("pressed", self, 'refresh')
	jail_filter.connect("pressed", self, 'refresh')
	farm_filter.connect("pressed", self, 'refresh')
	away_filter.connect("pressed", self, 'refresh')


	custom_field.connect("text_entered", self, 'on_custom_text_entered')
	custom_field.connect("text_changed", self, 'on_custom_text_changed')
	custom_combo.connect("item_selected", self, 'on_custom_combo_select')
	for key in settings.custom_fields:
		custom_combo.add_item(key)
		custom_combo.set_item_metadata(custom_combo.get_item_count() - 1, settings.custom_fields[key])

	if !settings.custom_field_enabled:
		sortNode.get_node("custom").hide()
		slavelist_node.get_node("customfieldline").hide()

	if expansion_enabled:
		sortNode.get_node("movement").set_button_icon(globals.movementimages['woman_walk_clothed'])
		sortNode.get_node("pregnant").set_button_icon(pregnant_image)
	else:
		sortNode.get_node("movement").hide()
		sortNode.get_node("pregnant").hide()

	if !settings.sex_interaction_buttons_enabled:
		slavelist_node.get_node("buttonline/sexbuttons/startsex").hide()
		slavelist_node.get_node("buttonline/sexbuttons/clearsex").hide()

func on_trait_combo_select(index):
	refresh()

func on_custom_text_entered(text):
	refresh()

func on_custom_text_changed(text):
	custom_combo.select(-1)

func on_custom_combo_select(index):
	custom_field.set_text(custom_combo.get_selected_metadata())
	refresh()

func open():
	for person in mansion.sexslaves.duplicate():
		if !person.canInteract() || globals.state.sexactions <= 0:
			mansion.sexslaves.erase(person)
	refresh()

func refresh():
	if !base_node.visible:
		return

	# update the sort string and button states
	var sortLabel = slavelist_node.get_node("sortingfilterline/sortingfields")
	var sortstr = str(sort_array) # substr to cut off the "[]"
	var sortNode = slavelist_node.get_node("sortline")
	sortLabel.set_text("Sorting on: " + sortstr.substr(1, sortstr.length() - 2))
	sortNode.get_node("name").set_pressed('name' in sort_array)
	sortNode.get_node("race").set_pressed('race' in sort_array)
	sortNode.get_node("beauty").set_pressed('beauty' in sort_array)
	sortNode.get_node("sex").set_pressed('sex' in sort_array)
	sortNode.get_node("grade").set_pressed('grade' in sort_array)
	sortNode.get_node("specialization").set_pressed('specialization' in sort_array)
	sortNode.get_node("movement").set_pressed('movement' in sort_array)
	sortNode.get_node("pregnant").set_pressed('pregnant' in sort_array)
	sortNode.get_node("str").set_pressed('str' in sort_array)
	sortNode.get_node("agi").set_pressed('agi' in sort_array)
	sortNode.get_node("maf").set_pressed('maf' in sort_array)
	sortNode.get_node("end").set_pressed('end' in sort_array)
	sortNode.get_node("ap").set_pressed('attr. points' in sort_array)
	sortNode.get_node("cour").set_pressed('cour' in sort_array)
	sortNode.get_node("conf").set_pressed('conf' in sort_array)
	sortNode.get_node("wit").set_pressed('wit' in sort_array)
	sortNode.get_node("charm").set_pressed('charm' in sort_array)
	sortNode.get_node("lp").set_pressed('learn points' in sort_array)
	sortNode.get_node("custom").set_pressed('custom' in sort_array)
	sortNode.get_node("job").set_pressed('job' in sort_array)
	sortNode.get_node("sleep").set_pressed('sleep' in sort_array)

	var personList = slavelist_node.get_node("ScrollContainer/VBoxContainer")

	# Get a sorted list of slaves, based on the current sort fields
	var sortedList = []
	for person in globals.slaves:
		sortedList.append(person)
	sortedList.sort_custom(self, 'slave_sort')


	var trait_filter = ""
	if trait_combo.get_item_count() > 0:
		trait_filter = trait_combo.get_item_text(trait_combo.selected)
	var use_trait_filter = false
	trait_combo.clear()
	var traitDict = {}
	for person in sortedList:
		if show_person(person):
			for trait in person.traits:
				traitDict[trait] = true
	var traitList = []
	for trait in traitDict.keys():
		traitList.append(trait)
	traitList.sort()
	trait_combo.add_item("")
	for trait in traitList:
		trait_combo.add_item(trait)
		if trait == trait_filter:
			# Only use the filter if there is a slave with it, otherwise reset it
			use_trait_filter = true
			trait_combo.select(trait_combo.get_item_count() - 1)

	var nodeIndex = 0
	for person in sortedList:
		var found = false
		for searchIndex in range(nodeIndex, personList.get_child_count()):
			var searchNode = personList.get_children()[searchIndex]
			if searchNode.has_meta('id') && searchNode.get_meta('id') == person.id:
				personList.move_child(searchNode, nodeIndex)
				if show_person(person):
					updateListNode(searchNode, person)
					searchNode.show()
				else:
					searchNode.hide()
				found = true
				nodeIndex += 1
				break
		if !found && show_person(person):
			var newline = createListNode(person)
			updateListNode(newline, person)
			personList.add_child(newline)
			personList.move_child(newline, nodeIndex)
			nodeIndex += 1


	# Remove any extra rows not needed anymore
	for clearIndex in range(nodeIndex, personList.get_children().size()):
		var clearNode = personList.get_children()[clearIndex]
		clearNode.hide()
		clearNode.queue_free()


	slavelist_node.get_node("buttonline/sexbuttons/clearsex").set_disabled(mansion.sexslaves.empty())
	var startsex_button = slavelist_node.get_node("buttonline/sexbuttons/startsex")
	if globals.state.sexactions < 1 || mansion.sexslaves.empty():
		startsex_button.set_disabled(true)
	elif mansion.sexslaves.size() >= 4 && globals.itemdict.aphroditebrew.amount < 1:
		startsex_button.set_disabled(true)
	else:
		startsex_button.set_disabled(false)
	var tooltip = ""
	if mansion.sexslaves.empty():
		tooltip = "No slaves selected"
	else:
		var names = PoolStringArray()
		for s in mansion.sexslaves:
			names.append(s.name)
		if mansion.sexslaves.size() >= 4:
			tooltip += "(ORGY - Aphrodite's Brew is required) "
		tooltip += "Slaves selected: " + names.join(", ")
	startsex_button.hint_tooltip = tooltip

func show_person(person):
	if person.away.at == "hidden":
		return false
	if trait_combo.get_item_count() > 0 && trait_combo.selected >= 0:
		var trait_filter = trait_combo.get_item_text(trait_combo.selected)
		if trait_filter != "" && !person.traits.has(trait_filter):
			return false
	if person.away.duration != 0:
		if !away_filter.pressed:
			return false
	elif person.sleep in ['jail']:
		if !jail_filter.pressed:
			return false
	elif person.sleep in ['farm']:
		if !farm_filter.pressed:
			return false
	else:
		if !mainsion_filter.pressed:
			return false
	return true

func openslavetab(person):
	mansion._on_listclose_pressed()
	mansion.openslavetab(person)

func createListNode(person):
	var personList = slavelist_node.get_node("ScrollContainer/VBoxContainer")
	var newline = slavelist_line_node.instance()
	newline.set_meta('id', person.id)
	var nameNode = newline.get_node("info/namerace/name")
	nameNode.connect("mouse_entered", globals, 'slavetooltip', [person])
	nameNode.connect("mouse_exited", globals, 'slavetooltiphide')
	nameNode.connect('pressed', self, 'openslavetab', [person])
	newline.get_node("info/portrait").connect("mouse_entered", globals, 'slavetooltip', [person])
	newline.get_node("info/portrait").connect("mouse_exited", globals, 'slavetooltiphide')
	newline.get_node("info/grade").connect("mouse_entered", globals, 'gradetooltip', [person])
	newline.get_node("info/grade").connect("mouse_exited", globals, 'hidetooltip')
	newline.get_node("info/spec").connect("mouse_entered", self, 'spectooltip', [person])
	newline.get_node("info/spec").connect("mouse_exited", globals, 'hidetooltip')
	if expansion_enabled:
		newline.get_node("info/movement").connect("mouse_entered", self, '_on_movement_mouse_entered', [person])
		newline.get_node("info/movement").connect("mouse_exited", globals, 'hidetooltip')

	if settings.sex_interaction_buttons_enabled:
		newline.get_node("info/buttons/meet").connect("pressed", self, 'meetpressed', [person])
		newline.get_node("info/buttons/sex").connect("pressed", self, 'sexpressed', [person])
	else:
		newline.get_node("info/buttons/meet").hide()
		newline.get_node("info/buttons/sex").hide()
		newline.get_node("info/buttons").columns = 1

	newline.get_node("info/buttons/job").connect("pressed", mansion, 'selectjob', [person])
	var sleep_node = newline.get_node("info/buttons/sleep")
	sleep_node.connect("pressed", mansion, 'sleeppressed', [sleep_node])
	sleep_node.connect("item_selected", mansion, 'sleepselect', [sleep_node])
	return newline

func meetpressed(person):
	mansion._on_listclose_pressed()
	mansion.sexslaves.clear()
	mansion.sexslaves.append(person)
	mansion.sexmode = 'meet'
	mansion._on_startbutton_pressed()

func sexpressed(person):
	if (mansion.sexslaves.has(person)):
		mansion.sexslaves.erase(person)
	else:
		mansion.sexslaves.append(person)
	refresh()

func startsexpressed():
	mansion._on_listclose_pressed()
	mansion.sexmode = 'sex'
	mansion._on_startbutton_pressed()

func clearsexpressed():
	mansion.sexslaves.clear()
	refresh()

func updateListNode(newline, person):
	var is_away = person.away.duration > 0
	# Don't reload the image if it didn't change, since it can be slow to reload images for a large slave list
	var portrait_node = newline.get_node("info/portrait")
	if !portrait_node.has_meta('imageportait') || (portrait_node.get_meta('imageportait') != person.imageportait):
		if person.imageportait != null:
			portrait_node.set_texture(globals.loadimage(person.imageportait))
		else:
			portrait_node.set_texture(null)
		portrait_node.set_meta('imageportait', person.imageportait)

	var nameNode = newline.get_node("info/namerace/name")
	nameNode.set_text(person.name_long())
	nameNode.set_disabled(is_away)
	if expansion_enabled:
		nameNode.set('custom_colors/font_color', ColorN(person.namecolor))
	newline.get_node("info/namerace/race").set_text(person.race)

	globals.description.person = person
	newline.get_node("info/namerace/beauty").set_text(globals.description.getbeauty(true).capitalize() + " (" + str(person.beauty) + ")")

	newline.get_node("info/sex").texture = globals.sexicon[person.sex]
	newline.get_node("info/grade").set_texture(globals.gradeimages[person.origins])
	newline.get_node("info/spec").set_texture(globals.specimages[str(person.spec)])
	if expansion_enabled:
		newline.get_node("info/movement").set_texture(globals.movementimages[str(globals.expansion.getMovementIcon(person))])

		if person.preg.duration > 0 && person.knowledge.has('currentpregnancy'):
			newline.get_node("info/pregnancy").set_texture(pregnant_image)
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
	else:
		newline.get_node("info/stats/splabel").set('custom_colors/font_color', null)

	newline.get_node("info/stats/courlabel").set_text(str(person.cour))
	newline.get_node("info/stats/conflabel").set_text(str(person.conf))
	newline.get_node("info/stats/witlabel").set_text(str(person.wit))
	newline.get_node("info/stats/charmlabel").set_text(str(person.charm))
	newline.get_node("info/stats/lplabel").set_text(str(person.learningpoints))
	if person.learningpoints >= variables.learnpointsperstat:
		newline.get_node("info/stats/lplabel").set('custom_colors/font_color', Color(0,1,0))
	else:
		newline.get_node("info/stats/lplabel").set('custom_colors/font_color', null)

	var custom_label = newline.get_node("info/custom")
	if custom_field.text == "":
		custom_label.set_text("")
		custom_label.set_tooltip("")
		custom_label.set_mouse_filter(2)
	else:
		custom_label.set_text(str(getCustom(person)))
		custom_label.set_tooltip(str(getCustom(person)))
		custom_label.set_mouse_filter(1)

	var meet_node = newline.get_node("info/buttons/meet")
	if person.canInteract() && globals.state.nonsexactions > 0:
		meet_node.set_disabled(is_away)
	else:
		meet_node.set_disabled(true)
	var sex_node = newline.get_node("info/buttons/sex")
	if !person.consent:
		sex_node.set('custom_colors/font_color', Color(1,0.2,0.2))
		sex_node.set('custom_colors/font_color_pressed', Color(1,0.2,0.2))
	else:
		sex_node.set('custom_colors/font_color', null)
		sex_node.set('custom_colors/font_color_pressed', null)
	if person.canInteract() && globals.state.sexactions > 0:
		sex_node.set_disabled(is_away)
	else:
		mansion.sexslaves.erase(person)
		sex_node.set_disabled(true)
	sex_node.set_pressed(mansion.sexslaves.has(person))

	var job_node = newline.get_node("info/buttons/job")
	if globals.jobs.jobdict.has(person.work):
		job_node.set_text(globals.jobs.jobdict[person.work].name)
	else:
		job_node.set_text("")
	if person.sleep == 'jail' || person.sleep == 'farm':
		job_node.set_disabled(true)
	else:
		job_node.set_disabled(is_away)

	var sleep_node = newline.get_node("info/buttons/sleep")
	if globals.sleepdict.has(person.sleep):
		sleep_node.set_text(globals.sleepdict[person.sleep].name)
		sleep_node.set_meta("slave", person)
		sleep_node.set_disabled(is_away)
	else:
		sleep_node.set_disabled(true)
		if person.sleep == 'farm':
			sleep_node.set_text("Farm")
		else:
			sleep_node.set_text(person.sleep)


func update_sort_array(field):
	var i = sort_array.find(field)
	if i >= 0:
		sort_array.remove(i)
	else:
		sort_array.append(field)
	refresh()

func reset_sort_array():
	sort_array.clear()
	trait_combo.select(0)
	refresh()

func slave_sort(first, second):
	for field in sort_array:
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
				var firstmove = movement_order.find(first.movement)
				var secondmove = movement_order.find(second.movement)
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
			"attr. points":
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
			"learn points":
				if first.learningpoints != second.learningpoints:
					return first.learningpoints >= second.learningpoints
			"custom":
				var firstcustom = getCustom(first)
				var secondcustom = getCustom(second)
				if !isNumeric(firstcustom) || !isNumeric(secondcustom):
					firstcustom = str(firstcustom)
					secondcustom = str(secondcustom)
				if firstcustom != secondcustom:
					return firstcustom <= secondcustom
			"job":
				if first.work != second.work:
					return globals.jobs.jobdict.keys().find(first.work) <= globals.jobs.jobdict.keys().find(second.work)
			"sleep":
				if first.sleep != second.sleep:
					# Sort jail at the end
					if first.sleep == 'jail':
						return false
					if second.sleep == 'jail':
						return true
					return globals.sleepdict.keys().find(first.sleep) <= globals.sleepdict.keys().find(second.sleep)
	return globals.slaves.find(first) <= globals.slaves.find(second) # keep the sort stable

func spectooltip(person):
	var text
	if person.spec == null:
		text = "Specialization can provide special abilities and effects and can be trained at Slavers' Guild. "
	else:
		var spec = globals.jobs.specs[person.spec]
		text = "[center]" + spec.name + '[/center]\n'+ spec.descript + "\n[color=aqua]" +  spec.descriptbonus + '[/color]'
	globals.showtooltip(text)

# Copied from expansion for movement tooltip
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

func getCustom(person):
	globals.currentslave = person
	var result = globals.evaluate(custom_field.text)
	return result

func isNumeric(value):
	return typeof(value) in [TYPE_INT, TYPE_REAL]
