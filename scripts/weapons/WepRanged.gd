extends "res://scripts/weapons/Wep.gd"

export var bullet : PackedScene

func attack() -> void:
	if(is_attack_enabled()):
		var bullet_instance : KinematicBody2D = bullet.instance()
		bullet_instance.set_direction(get_user().get_bullet_direction())
		bullet_instance.position = $bulletInstancePosition.global_position
		bullet_instance.damage = damage
		get_parent().get_parent().get_parent().add_child(bullet_instance)
		.attack()
