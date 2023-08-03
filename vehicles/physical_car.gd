extends RigidBody2D

var active = false
var car_zone = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO

var front_wheel = Vector2.ZERO
var rear_wheel = Vector2.ZERO
var turn  = 0

var engine_power = 800
var braking = -450
var max_speed_reverse =   250

var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015

var wheel_base = 20
var steering_angle = 15
var steer_direction =0

var slip_speed = 300  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction
var traction = 0.7  # Low-speed traction

# Called when the node enters the scene tree for the first time.
func _ready():
	var lines= Line2D.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	acceleration =  Vector2.ZERO
	var enter = Input.is_action_just_pressed("ui_text_newline")
	if(active):
		get_input(delta )
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	
	#move_and_collide(velocity * delta)
	apply_force(velocity )
	#apply_impulse(velocity * delta)

	if(enter):
		if(car_zone && !active):
			
			get_parent().remove_player()
			active =true
			$Camera2D.make_current()
		elif(active):
			get_parent().add_player()
			active = false
			
	

func get_input(delta):
	
	turn =Input.get_axis("ui_left", "ui_right")
	steer_direction = turn * deg_to_rad( steering_angle)
	if (Input.is_action_pressed("ui_up")):
		acceleration = transform.x * engine_power
	if (Input.is_action_pressed("ui_down")):
		acceleration = transform.x * braking
		
		

		#velocity = transform.x * SPEED 
	
	
func apply_friction():
	if(velocity.length() < 5):
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force +friction_force
	
func calculate_steering(delta):
	rear_wheel = position - transform.x * wheel_base/2.0
	front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	traction = traction_slow
	
	if velocity.length() > slip_speed:
		var newLine = Line2D.new()
		newLine.add_point(front_wheel)
		traction = traction_fast
		
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp( new_heading * velocity.length(), traction ) #new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle() 

	

func _on_area_2d_body_entered(body):
	if(body.name == "Player"):
		car_zone = true


func _on_area_2d_body_exited(body):
	if(body.name == "Player"):
		car_zone = false

