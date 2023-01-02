extends Node

var enabled = true

var fields = {
  "": "",
  "Is Grateful": "person.traits.has('Grateful')",

  ##########
  # These require Aric's Mod
  ##########
  "Luxury Satisfied": "'Satisfied' if (person.traits.has('Grateful') || person.countluxury(false).luxury >= person.calculateluxury()) else 'Low luxury'",
  "Is Ovulating": "' Yes' if person.preg.ovulation_stage == 1 else 'No'",
  "Exhibition Fetish": "str(globals.fetishopinion.find(person.fetish.exhibitionism)) + ' ' + person.fetish.exhibitionism",
  # Quickly find slaves with a lust vice that are not in a sex job
  "Lust Vice": "'Unknown' if not person.mind.vice_known else ('no' if person.mind.vice != 'lust' else ('Lusty - work' if globals.jobs.jobdict[person.work].tags.has('sex') else 'Lusty'))",
}
