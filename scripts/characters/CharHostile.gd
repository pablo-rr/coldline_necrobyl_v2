extends "res://scripts/characters/Char.gd"

const MOVEMENT_INNER_WALL : String = "inner_wall"
const MOVEMENT_OUTER_WALL : String = "outer_wall"
const MOVEMENT_RANDOM : String = "random"

export (int, 5, 100, 5) var attack_damage : int = 0
export (float, 0.05, 5.0, 0.05) var time_between_attacks : float = 2.0
export (String, "inner_wall", "outer_wall", "random") var movement_type
export (float, 1.0, 1000, 0.2) var attack_range : float = 95.0
export (float, 1.0, 1000, 0.2) var vision_range : float = 700.0

onready var player : KinematicBody2D = get_parent().get_node("player")
onready var time_since_last_attack : float = 0

func _ready() -> void:
	set_character_id(CHARACTER_ID_HOSTILE)
	
func damage(quantity : int) -> void:
	.damage(quantity)
#	remove hostile when health drops below 0
	if(get_health() <= 0):
		queue_free()
	
func _physics_process(delta : float) -> void:
	update_time_since_last_attack(delta)
	move_towards_player_when_player_in_sight()

func move_towards_player_when_player_in_sight() -> void:
	if(is_seeing_player()):
		get_player_position_from_self()
		move_and_slide(get_player_position_from_self().normalized() * walkspeed)

# if CharHostile sees player and is in range, yield then attack. resets if player leaves attack range
# needs delta as it is done every frame
func update_time_since_last_attack(delta : float) -> void:
	if(is_seeing_player() and is_player_in_attack_range()):
		time_since_last_attack += delta
	else:
		time_since_last_attack = 0
		
	if(time_since_last_attack >= time_between_attacks):
		time_since_last_attack = 0

func get_distance_between_self_and_player() -> float:
	var player_position_from_self : Vector2 = player.position - position
	var pythags_theorem_a : float = pow(player_position_from_self.x, 2)
	var pythags_theorem_b : float = pow(player_position_from_self.y, 2)
	var pythags_theorem_c : float = sqrt(pythags_theorem_a + pythags_theorem_b)
	return pythags_theorem_c
	
func get_player_position_from_self() -> Vector2:
	return player.position - position
	
func is_seeing_player() -> bool:
	$playerVisualizer.cast_to = get_player_position_from_self()
#	first check if there's something colliding, if true, check if it is a char, and if true, check if is a player
	if($playerVisualizer.get_collider() and 
	$playerVisualizer.get_collider().get("character_id") != null and 
	$playerVisualizer.get_collider().get_character_id() == CHARACTER_ID_PLAYABLE and
	is_player_in_vision_range()):
		return true
	else:
		return false
		
func is_player_in_attack_range() -> bool:
	if(get_distance_between_self_and_player() <= attack_range):
		return true
	else:
		return false
		
func is_player_in_vision_range() -> bool:
	if(get_distance_between_self_and_player() <= vision_range):
		return true
	else:
		return false
