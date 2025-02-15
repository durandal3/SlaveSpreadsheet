extends Node


# Location filter settings
# Whether to show the filter buttons
var show_location_filters = true
# Default state of each location
var default_mansion_visible = true
var default_jail_visible = false
var default_farm_visible = false
var default_away_visible = false


# Whether to show the meet/sex interaction buttons
var sex_interaction_buttons_enabled = true
# Whether to allow meet/sex interactions with slaves that are on the farm
var allow_interaction_with_farm_slaves = true


# Settings for custom fields - when enabled, provides a text box where
# code can be entered to create a custom field for any value desired,
# that can be sorted on like other fields.

# Set to "true" to enable (or "false" to disable) the custom field
var custom_field_enabled = false

# Pre-defined fields that can be quickly selected. Left of the ":" is
# the name used when selecting, right is the code it will apply.
# New fields can be added here.
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
