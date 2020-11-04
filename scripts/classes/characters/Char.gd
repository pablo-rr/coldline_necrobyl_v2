extends KinematicBody2D

signal health_changed
signal walkspeed_changed
signal position_changed

const ANIMATION_IDLE = "idle"
const ANIMATION_WALK = "walk"
const CHARACTER_ID_PLAYABLE : String = "player"
const CHARACTER_ID_NPC : String = "NPC"
const CHARACTER_ID_HOSTILE : String = "hostile"

export (String, "null", "NPC", "hostile", "player") var character_id
export var walkspeed : int = 300
export var health : int = 100

# vanilla values when first loaded (unaltered), to be able to come back to them if they are modified 
onready var vanilla_health : int = health
onready var vanilla_walkspeed : int = walkspeed
onready var dead : bool = false
onready var attack_enabled : bool = true
onready var last_position : Vector2 = position

func _physics_process(delta : float) -> void:
	last_position = position

func fix_overheal():
	if(health > vanilla_health):
		health = vanilla_health
		
func fix_overdamage():
	if(health < 0):
		health = 0

func receive_damage(quantity : int) -> void:
	health -= quantity
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
	
func set_attack_enabled(new_enabled : bool) -> void:
	attack_enabled = new_enabled
	
func get_attack_enabled() -> bool:
	return attack_enabled
	
func get_character_id() -> String:
	return character_id;
	
func get_last_position() -> Vector2:
	return last_position
