extends "res://scripts/weapons/Wep.gd"

func _on_hitbox_body_entered(body):
	var collisionLayers = preload("res://scripts/utility/CollisionLayers.gd").new().CollisionLayers
	if(body.collision_layer == collisionLayers.COLLISION_VALUE_PLAYER):
		body.receive_damage(damage)
		
func attack() -> void:
	set_attack_enabled(false)
	yield_attack()
	$animations.play("attack")
	$attackSound.play(0.0)
