### <ModFile> ###

var slave_spreadsheet = load(globals.modfolder + "/SlaveSpreadsheet/slave_spreadsheet.gd").new()

<AddTo -1>
func _ready():
	slave_spreadsheet.init(self, get_node("slavelist"))


func slavelist():
	slave_spreadsheet.refresh()
