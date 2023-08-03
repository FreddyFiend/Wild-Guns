extends DirectionalLight2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(0.1 * delta)
	
	if rotation > 3:
		make_night()
	print(color)
	
func make_night():

	color = Color(1,1,1,0)

	
	
