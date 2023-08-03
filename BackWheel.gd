extends Line2D


var point_length = 500
var front_point = Vector2.ZERO
var rear_point = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	if(get_parent().traction < 0.2):
		rear_point = get_parent().rear_wheel
		
		add_point(rear_point)
	else:
		remove_point(-1)
		
	while get_point_count()> point_length:
		remove_point(0)
	
