extends "res://scripts/classes/characters/Char.gd"
class_name CharHostile

const MOVEMENT_INNER_WALL : String = "inner_wall"
const MOVEMENT_OUTER_WALL : String = "outer_wall"
const MOVEMENT_RANDOM : String = "random"

export (int, 0, 100, 1) var attack_damage : int = 0.0
export (float, 0.1, 3, 0.05) var time_between_attacks : float = 0.0
export (int, 60, 180, 2) var angle_of_vision : int = 88
export (String, "inner_wall", "outer_wall", "random") var movement_type

onready var seeing_player : bool = false

func _ready() -> void:
	pass
	
func _physics_process(delta : float) -> void:
	print(is_seeing_player())
	
func set_seeing_player(new_seeing : bool) -> void:
	seeing_player = new_seeing
	
func get_seeing_player() -> bool:
	return seeing_player
	
func is_seeing_player() -> bool:
	var player_position : Vector2 = get_parent().get_node("player").position
	var distance_between_self_and_player : Vector2 = player_position - position
	$toPlayerRaycast.cast_to = Vector2(distance_between_self_and_player)
#	first check if there's something colliding, if true, check if it is a char, and if true, check if is a player
	if($toPlayerRaycast.get_collider() and 
	$toPlayerRaycast.get_collider().get("character_id") != null and 
	$toPlayerRaycast.get_collider().get_character_id() == CHARACTER_ID_PLAYABLE):
		return true
	else:
		return false
