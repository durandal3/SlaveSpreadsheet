extends Node

var fields = {
  "": "",
  "Is Ovulating": "' Yes' if person.preg.ovulation_stage == 1 else 'No'",
  "Exhibition Fetish": "str(globals.fetishopinion.find(person.fetish.exhibitionism)) + ' ' + person.fetish.exhibitionism",
}