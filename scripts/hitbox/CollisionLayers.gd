class CollisionLayers:
	extends CollisionObject2D

	const COLLISION_VALUE_PLAYER = 1
	const COLLISION_VALUE_PLAYER_DAMAGER = 2
	const COLLISION_VALUE_HOSTILE = 4
	const COLLISION_VALUE_HOSTILE_DAMAGER = 8
	const COLLISION_VALUE_PICKUP = 16
	const COLLISION_VALUE_WALL = 32
	const COLLISION_VALUE_DESTROYABLE = 64
	
	func set_all_mask_bits(object : CollisionObject2D, new_bool : bool):
		object.set_collision_mask_bit(1, new_bool)
		var iterator : int = 2
		var iterations : int = 16
		for iteration in iterations:
			object.set_collision_mask_bit(iterator, new_bool)
			iterator = pow(iterator, 2)
			print(iterator)
			
	func set_all_layer_bits(object : CollisionObject2D, new_bool : bool):
		object.set_collision_layer_bit(1, new_bool)
		var iterator : int = 2
		var iterations : int = 16
		for iteration in iterations:
			object.set_collision_layer_bit(iterator, new_bool)
			iterator = pow(iterator, 2)
			print(iterator)
			
	func set_all_scene_colliders_mask_bits_player_damager(object : CollisionObject2D, new_bool : bool):
		object.set_collision_mask_bit(COLLISION_VALUE_HOSTILE, new_bool)
		object.set_collision_mask_bit(COLLISION_VALUE_WALL, new_bool)
		object.set_collision_mask_bit(COLLISION_VALUE_DESTROYABLE, new_bool)
		
	func set_all_scene_colliders_mask_bits_hostile_damager(object : CollisionObject2D, new_bool : bool):
		object.set_collision_mask_bit(COLLISION_VALUE_PLAYER, new_bool)
		object.set_collision_mask_bit(COLLISION_VALUE_WALL, new_bool)
		object.set_collision_mask_bit(COLLISION_VALUE_DESTROYABLE, new_bool)
