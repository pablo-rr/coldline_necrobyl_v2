extends Area2D

onready var collision_layers = preload("res://scripts/utility/CollisionLayers.gd").new().CollisionLayers.new()

func is_body_the_player(body : KinematicBody2D) -> bool:
	if(body.collision_layer == collision_layers.COLLISION_VALUE_PLAYER):
		return true
	else:
		return false
