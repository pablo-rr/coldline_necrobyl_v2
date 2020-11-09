extends "res://scripts/characters/Char.gd"

signal hostile_moved

const FOLLOW_STATE_PLAYER = 1000
const FOLLOW_STATE_PATH = 1001
const MOVEMENT_INNER_WALL : String = "inner_wall"
const MOVEMENT_OUTER_WALL : String = "outer_wall"
const MOVEMENT_RANDOM : String = "random"

export (int, 5, 100, 5) var attack_damage : int = 0
export (float, 0.05, 5.0, 0.05) var time_between_attacks : float = 2.0
export (String, "inner_wall", "outer_wall", "random") var movement_type
export (float, 1.0, 1000, 0.2) var attack_range : float = 95.0
export (float, 1.0, 1000, 0.2) var vision_range : float = 700.0

# we use the delta_timer class for the movement AI. to make the AI more interesting, it
# yields when changing from "follow_player" to "follow_path", and as the AI is in the
# game loop, we need to yield it with the delta value.
onready var delta_timer = preload("res://scripts/utility/DeltaTimer.gd").new().DeltaTimer.new()
onready var player : KinematicBody2D = get_parent().get_node("player")
onready var time_since_last_attack : float = 0
onready var path_point : int = 0
onready var path : Area2D = null
onready var follow_state : int = 0
# used when the player leaves vision. when confused, he won't be able to follow the path for some seconds
onready var confused : bool = false

func _ready() -> void:
	set_character_id(CHARACTER_ID_HOSTILE)
	delta_timer.set_delta_timer(rand_range(2.2, 3.8))
	delta_timer.connect("delta_time_started", self, "set_confused", [true])
	delta_timer.connect("delta_time_completed", self, "set_confused", [false])
	
func receive_damage(quantity : int) -> void:
	.receive_damage(quantity)
#	remove hostile when health drops below 0
	if(get_health() <= 0):
		queue_free()
	
func _physics_process(delta : float) -> void:
	AI_movement(delta)
#	attack_player_when_in_range()

# change movement from follow player to follow path
func AI_movement(delta : float) -> void:
	update_follow_state()
	delta_timer.update_delta_time(delta)
	if(follow_state == FOLLOW_STATE_PATH and !confused):
		follow_path()
	elif(follow_state == FOLLOW_STATE_PLAYER):
		delta_timer.reset_delta_timer()
		move_towards_player_when_player_in_sight()

func move_towards_player_when_player_in_sight() -> void:
	if(is_seeing_player()):
		get_player_position_from_self()
		move_and_slide(get_player_position_from_self().normalized() * walkspeed)
		
func get_nearest_path_point() -> int:
	var path_points : int = path.get_node("points").get_child_count()
	var nearest_distance : float = 999999.9
	var path_point : int = 0
	for point in path_points:
		var distance : float = get_distance_to_node(path.get_node("points/p" + str(point)))
		if(distance < nearest_distance):
			nearest_distance = distance
			path_point = point
			
	return path_point
		
func follow_path() -> void:
	if(path != null):
		var path_points : int = path.get_node("points").get_child_count()
		var point_node : Position2D = path.get_node("points/p" + str(path_point))
		var point_position : Vector2 = point_node.global_position
		var path_direction = (point_position - position).normalized()
		var difference : Vector2 = position - point_position
		if(difference.x < 2 and difference.y < 2 and difference.x > -2 and difference.y > -2):
			update_path_point(path_points)
		
		look_at(point_node.position)
		move_and_slide(path_direction * walkspeed)
		
func update_path_point(path_points : int) -> void:
#	path_points-1 is the last path_point available, as they start by 0
	if(path_point == path_points - 1):
		path_point = 0
	else:
		path_point += 1

# if CharHostile sees player and is in range, yield then attack. resets if player leaves attack range
# needs delta as it is done every frame
func update_time_since_last_attack(delta : float) -> void:
	if(is_seeing_player() and is_player_in_attack_range()):
		time_since_last_attack += delta
	else:
		time_since_last_attack = 0
		
	if(time_since_last_attack >= time_between_attacks):
		time_since_last_attack = 0
		
func attack_player_when_in_range() -> void:
	if(is_player_in_attack_range() and is_seeing_player()):
		bullet_direction = get_player_position_from_self()
		get_weapon().attack()
		
# if the weapon has the method "attack()", it is ranged, as melees use Area signals
func attack_if_is_ranged_weapon() -> void:
	if(get_weapon().has_method("attack")):
		get_weapon().attack()
		
func update_follow_state():
	if(is_seeing_player()):
		follow_state = FOLLOW_STATE_PLAYER
	else:
		follow_state = FOLLOW_STATE_PATH
		
func is_player_in_attack_range() -> bool:
	if(get_distance_to_node(player) <= attack_range):
		return true
	else:
		return false
		
func is_player_in_vision_range() -> bool:
	if(get_distance_to_node(player) <= vision_range):
		return true
	else:
		return false
		
func set_path(new_path : Area2D) -> void:
	path = new_path
		
func set_confused(new_confused : bool) -> void:
#	print(new_confused)
	confused = new_confused
	if(new_confused == true):
		print(get_nearest_path_point())
		path_point = get_nearest_path_point()
	
func get_confused() -> bool:
	return confused
	
func get_distance_to_node(node : Node2D):
	var node_position_from_self : Vector2 = node.position - position
	var pythags_theorem_a : float = pow(node_position_from_self.x, 2)
	var pythags_theorem_b : float = pow(node_position_from_self.y, 2)
	var pythags_theorem_c : float = sqrt(pythags_theorem_a + pythags_theorem_b)
	return pythags_theorem_c
	
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
#	the entire node rotates with its base (charHostile) when looking at player, including the Raycast
#	the next line fixes the Raycast rotation to always be 0 in global rotation values
	$playerVisualizer.rotation_degrees = -rotation_degrees
#	first check if there's something colliding, if true, check if it is a char, and if true, check if is a player
	if($playerVisualizer.get_collider() and 
	$playerVisualizer.get_collider().get("character_id") != null and 
	$playerVisualizer.get_collider().get_character_id() == CHARACTER_ID_PLAYABLE and
	is_player_in_vision_range()):
		look_at(player.position)
		return true
	else:
		return false
