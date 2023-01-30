extends Node


# Whether to show the meet/sex interaction buttons
var sex_interaction_buttons_enabled = true

# Settings for custom fields - when enabled, provides a text box where code can be entered to create a custom field for any value desired, that works and can be sorted on like other fields. Can be useful to find slaves matching some condition or search for specific traits.

# Set to "true" to enable (or "false" to disable) the custom field
var custom_field_enabled = false

# Pre-defined fields that can be quickly selected. Left of the ":" is the name used when selecting, right is the code it will apply.
# New ones can be added here.
var custom_fields = {
  "": "",
  "Current Health %": "100 * (person.health / person.stats.health_max)",
  "Is Grateful": "person.traits.has('Grateful')",
  "Stress": "person.stress",
  "Lewdness": "person.lewdness",

  ##########
  # These require Aric's Mod. Uncomment (remove the "#") to enable
  ##########
#  "Luxury Satisfied": "'Satisfied' if (person.traits.has('Grateful') || person.countluxury(false).luxury >= person.calculateluxury()) else 'Low luxury'",
#  "Is Ovulating": "'Yes' if person.preg.ovulation_stage == 1 else 'no'",
#  "Exhibition Fetish": "str(globals.fetishopinion.find(person.fetish.exhibitionism)) + ' ' + person.fetish.exhibitionism",
  # Quickly find slaves with a lust vice that are not in a sex job
#  "Lust Vice": "'Unknown' if not person.mind.vice_known else ('no' if person.mind.vice != 'lust' else ('Lusty - work' if globals.jobs.jobdict[person.work].tags.has('sex') else 'Lusty'))",
}
