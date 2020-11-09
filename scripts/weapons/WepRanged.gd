extends "res://scripts/weapons/Wep.gd"

export var bullet : PackedScene
export (int, 1, 9999, 1) var ammo : int = 1

func attack() -> void:
		if(is_attack_enabled() and ammo > 0):
			.attack()
			ammo -= 1
			$animations.play("attack")
			$attackSound.play(0.0)
			var bullet_instance : KinematicBody2D = bullet.instance()
			bullet_instance.set_direction(get_user().get_bullet_direction())
			bullet_instance.position = $bulletInstancePosition.global_position
			bullet_instance.damage = damage
			get_parent().get_parent().get_parent().add_child(bullet_instance)
			yield_attack()
