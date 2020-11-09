extends Node

export (int, 5, 100, 5) var damage : int = 20
export (float, 0.06, 10.0, 0.02) var time_between_attacks : float = 1.0

var attack_enabled : bool = true

func attack() -> void:
	if(is_attack_enabled()):
		set_attack_enabled(false)
		
func yield_attack() -> void:
	yield(get_tree().create_timer(time_between_attacks), "timeout")
	set_attack_enabled(true)

func is_attack_enabled() -> bool:
	return attack_enabled
	
func set_attack_enabled(new_enabled : bool) -> void:
	attack_enabled = new_enabled
	
func get_user() -> Node:
	return get_parent().get_parent()
