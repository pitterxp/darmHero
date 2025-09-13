extends Node

# hat user das intro bereits gesehen?
var intro_first_time: bool = true

# User Auswahl: Schwierigkeitsgrad
var difficulty_setting: String = ""

# Runden Ergebnis
var current_round_data = [
	{"round_won": false, "current_round": 0, "enemies_spawned": 0, "enemies_killed_in_round": 0, "xp": 0, "money": 0}
]
