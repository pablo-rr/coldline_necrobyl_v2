extends KinematicBody2D

signal health_changed
signal walkspeed_changed
signal position_changed

const ANIMATION_IDLE = "idle"
const ANIMATION_WALK = "walk"
const CHARACTER_ID_PLAYABLE : String = "player"
const CHARACTER_ID_NPC : String = "NPC"
const CHARACTER_ID_HOSTILE : String = "hostile"
const WEAPON_FISTS : String = "path to node"

export var walkspeed : int = 300
export var health : int = 100

# vanilla values when first loaded (unaltered), to be able to come back to them if they are modified 
onready var vanilla_health : int = health
onready var vanilla_walkspeed : int = walkspeed
onready var dead : bool = false
onready var last_position : Vector2 = position

# load the at _ready() of each Child class with set_character_id() [CharPlayable and CharHostile]
var character_id : String
var bullet_direction : Vector2

func get_weapon() -> Node2D:
	return $weaponSlot.get_children()[0]

func set_bullet_direction(new_direction : Vector2) -> void:
	bullet_direction = new_direction
	
func get_bullet_direction() -> Vector2:
	return bullet_direction

func fix_overheal():
	if(health > vanilla_health):
		health = vanilla_health
		
func fix_overdamage():
	if(health < 0):
		health = 0

func update_last_position() -> void:
	last_position = position

func receive_damage(quantity : int) -> void:
	health -= quantity
	print(health)
	fix_overdamage()
	
func heal(quantity : int) -> void:
	health += quantity
	fix_overheal()
	
func get_walkspeed() -> int:
	return walkspeed
	
func set_walkspeed(new_walkspeed : int) -> void:
	walkspeed = new_walkspeed
	
func set_vanilla_walkspeed() -> void:
	walkspeed = vanilla_walkspeed
	
func get_health() -> int:
	return health
	
func set_health(new_health : int) -> void:
	health = new_health
	fix_overheal()
	fix_overdamage()
	
func set_vanilla_health() -> void:
	health = vanilla_health
	
func set_dead(new_dead : bool) -> void:
	dead = new_dead
	
func is_dead() -> bool:
	return dead
	
func set_character_id(new_id) -> void:
	character_id = new_id
	
func get_character_id() -> String:
	return character_id
	
func get_last_position() -> Vector2:
	return last_position
