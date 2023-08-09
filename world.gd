extends Node2D

@onready var playerPath = load("res://player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func remove_player():
	var player = get_node("Player")
	remove_child(player)

func add_player():
	var player = playerPath.instantiate()
	var car_node =  get_node("Car")
	player.position = car_node.transform.origin - car_node.transform.y * 24
	add_child(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
