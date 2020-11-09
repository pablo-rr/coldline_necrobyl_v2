extends "res://scripts/characters/Char.gd"

signal player_moved

onready var lastMousePosition : Vector2 = get_global_mouse_position()

func _ready() -> void:
	set_character_id(CHARACTER_ID_PLAYABLE)
	
func _physics_process(delta : float) -> void:
	if(!is_dead()):
		delta_inputs()
		set_player_rotation()
		camera_zoom()
		
func _input(event : InputEvent) -> void:
	pass

func set_player_rotation() -> void:
	look_at(get_global_mouse_position())

# mueve al jugador con WASD
func delta_inputs() -> void:
	movement_inputs()
	attack_inputs()
	
func movement_inputs() -> void:
	var motion : Vector2 = Vector2(0, 0)
	
	if(Input.is_action_pressed("event_s")):
		motion.y = Input.get_action_strength("event_s")
		emit_signal("player_moved")
	elif(Input.is_action_pressed("event_w")):
		motion.y = -Input.get_action_strength("event_w")
		emit_signal("player_moved")
	if(Input.is_action_pressed("event_a")):
		motion.x = -Input.get_action_strength("event_a")
		emit_signal("player_moved")
	elif(Input.is_action_pressed("event_d")):
		motion.x = Input.get_action_strength("event_d")
		emit_signal("player_moved")
	
	motion = motion.normalized() # con esto el jugador se mueve a la velocidad correcta en diagonales
	motion *= walkspeed
	move_and_slide(motion)
	
func attack_inputs() -> void:
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)):
		bullet_direction = get_global_mouse_position() - position
		get_weapon().attack()

func camera_zoom() -> void:
	if(Input.is_action_pressed("event_lshift")):
		var fixedMousePosition = get_viewport().size/2 - get_viewport().get_mouse_position()
		$cam.offset.x = lerp($cam.offset.x, -fixedMousePosition.x/2.75, 0.2)
		$cam.offset.y = lerp($cam.offset.y, -fixedMousePosition.y/2.75*16/9, 0.2)
	else:
		$cam.offset = lerp($cam.offset, Vector2(0, 0), 0.2)
