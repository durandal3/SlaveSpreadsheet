extends Node

var fields = {
  "": "",
  "Is Ovulating": "person.preg.ovulation_stage == 1",
  "Exhibition Fetish": "str(globals.fetishopinion.find(person.fetish.exhibitionism)) + ' ' + person.fetish.exhibitionism",
}