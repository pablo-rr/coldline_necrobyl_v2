extends KinematicBody2D

onready var collision_layers = preload("res://scripts/utility/CollisionLayers.gd").new().CollisionLayers

export (String, "null", "hostile", "player") var bullet_id : String
export (int, 100, 2000, 1) var travel_speed : int = 800
export (float, 0.05, 10.0, 0.05) var time_until_disappear : float = 5.0

var direction : Vector2
var damage : int

func _physics_process(delta : float) -> void:
	move_and_slide(direction.normalized() * travel_speed)
	decrease_time_until_disappear(delta)
	
func set_direction(new_direction : Vector2) -> void:
	direction = new_direction
	
func get_direction() -> Vector2:
	return direction
	
func set_damage(new_damage : int) -> void:
	damage = new_damage
	
func get_damage() -> int:
	return damage

# this will remove the bullet after some time to free some memory
func decrease_time_until_disappear(delta : float) -> void:
	time_until_disappear -= delta
	if(time_until_disappear <= 0):
		queue_free()

func _on_hitbox_body_entered(body : PhysicsBody2D):
#	damage Characters
	if(body.collision_layer == collision_layers.COLLISION_VALUE_HOSTILE or
	body.collision_layer == collision_layers.COLLISION_VALUE_PLAYER):
		body.receive_damage(damage)
	
#	remove on hit
	if(body.collision_layer == collision_layers.COLLISION_VALUE_HOSTILE or
	body.collision_layer == collision_layers.COLLISION_VALUE_PLAYER or
	body.collision_layer == collision_layers.COLLISION_VALUE_WALL or
	body.collision_layer == collision_layers.COLLISION_VALUE_DESTROYABLE):
		queue_free()
