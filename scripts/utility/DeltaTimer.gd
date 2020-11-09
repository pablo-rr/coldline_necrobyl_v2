class DeltaTimer:
#	Use to yield code inside "_process" and "_physics_process"
	
	extends Node2D
	
	signal delta_time_started
#	connect method yielded to this signal in the used script
	signal delta_time_completed

	var able_to_set_delta_timer : bool = true
	var delta_time : float = 0
	var delta_time_vanilla : float = 0

	func set_delta_timer(time : float) -> void:
		if(able_to_set_delta_timer):
			able_to_set_delta_timer = false
			delta_time = time
			delta_time_vanilla = time
			
	func reset_delta_timer() -> void:
		delta_time = delta_time_vanilla
		emit_signal("delta_time_started")
		
	func update_delta_time(delta : float) -> void:
		delta_time -= delta
		if(delta_time <= 0):
			emit_signal("delta_time_completed")
