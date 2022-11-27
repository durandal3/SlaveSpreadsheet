### <ModFile> ###

var slave_spreadsheet = load(globals.modfolder + "/SlaveSpreadsheet/slave_spreadsheet.gd").new()

<AddTo -1>
func _ready():
	slave_spreadsheet.init(self, get_node("slavelist"))


func slavelist():
	slave_spreadsheet.refresh()


<AddTo 30>
func _input(event):
	if get_focus_owner() == get_node("slavelist/slavelist/customfieldline/field") && get_node("MainScreen").is_visible_in_tree():
		return
