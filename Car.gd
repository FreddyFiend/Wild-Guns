extends CharacterBody2D

@onready var camera = $Camera2D
@onready var headlight1 = $Headlight_1
@onready var headlight2 = $Headlight_2
@onready var _lines = get_parent().get_node("Lines")

@onready var _front_left_wheel_line = Line2D
@onready var _front_right_wheel_line = Line2D
@onready var _rear_left_wheel_line = Line2D
@onready var _rear_right_wheel_line = Line2D

var is_drifting = false
var active = false
var car_zone = false
var direction = Vector2.ZERO

var front_wheel = Vector2.ZERO
var rear_wheel = Vector2.ZERO
var turn  = 0

# This represents the player's inertia.
var push = 100

var engine_power = 400
var braking = -450
var max_speed_reverse =   250

var acceleration = Vector2.ZERO

var friction = -0.9
var drag = -0.0015

var wheel_base = 20
var steering_angle = 12
var steer_direction =0

var slip_speed = 160  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction
var traction = 0.7  # Low-speed traction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var lines= Line2D.new()
	
	# Replace with function body.


func add_drift_line():
	_front_left_wheel_line = Line2D.new()
	_front_right_wheel_line = Line2D.new()
	_rear_left_wheel_line= Line2D.new()
	_rear_right_wheel_line= Line2D.new()
	
	_front_left_wheel_line.width = 1
	_front_right_wheel_line.width = 1
	_rear_left_wheel_line.width = 1
	_rear_right_wheel_line.width = 1
	
	_front_left_wheel_line.default_color = Color(255,255,255,0.6)
	_front_right_wheel_line.default_color = Color(255,255,255,0.6)
	_rear_left_wheel_line.default_color = Color(255,255,255,0.6)
	_rear_right_wheel_line.default_color = Color(255,255,255,0.6)
	
	_lines.add_child(_front_left_wheel_line)
	_lines.add_child(_front_right_wheel_line)
	_lines.add_child(_rear_left_wheel_line)
	_lines.add_child(_rear_right_wheel_line)

func draw_drift_line():
	_front_left_wheel_line.add_point(transform.origin - transform.y * 6 + transform.x * 10 )
	_front_right_wheel_line.add_point(transform.origin - transform.y * -6 + transform.x * 10 )
	_rear_left_wheel_line.add_point(transform.origin - transform.y * 6 + transform.x * -10 )
	_rear_right_wheel_line.add_point(transform.origin - transform.y * -6 + transform.x * -10 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	acceleration =  Vector2.ZERO
	var enter = Input.is_action_just_pressed("ui_text_newline")
	headlight1.hide()
	headlight2.hide()
	if(active):
		headlight1.show()	
		headlight2.show()	
		get_input(delta )
		
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	
	var drone =  0.7 -  velocity.length() / 1000 
	
	#print(drone)
	camera.zoom = Vector2(drone, drone)
	
	apply_collision()
	
	
	
	
	move_and_slide()


	
	if(enter):
		if(car_zone && !active):
			
			get_parent().remove_player()
			active =true
			$Camera2D.make_current()
		elif(active):
			get_parent().add_player()
			active = false
			
	



func apply_collision():
	
	for index in get_slide_collision_count():
		#print(index)
		var collision = get_slide_collision(index)
		#print(-collision.get_normal() * velocity.length() *2)
		#print(collision)
	#	var collision = get_slide_collision(index)
		#print(collision.get_collider().name)
		if collision.get_collider().is_in_group("bodies"):
			
			#print('Flooooor')
			#collision.get_collider().apply_central_impulse(velocity+ Vector2(5,5))
	#		print('In the bodies')
			collision.get_collider().apply_central_impulse(-collision.get_normal()* velocity.length() *0.8 )
			acceleration -=  velocity * 8
			
			#collision.collider.apply_central_impulse(-collision.normal * push)
	#move_and_collide(velocity * delta)
	#move_and_collide(velocity * delta, )
	#print(get_last_slide_collision())
	


func get_input(delta):
	
	turn =Input.get_axis("ui_left", "ui_right")
	steer_direction = turn * deg_to_rad( steering_angle)
	if (Input.is_action_pressed("ui_up")):
		acceleration = transform.x * engine_power
	if (Input.is_action_pressed("ui_down")):
		acceleration = transform.x * braking
		
	
	
	
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
	
	
	
	if velocity.length() > slip_speed && turn:
		
		traction = traction_fast
		
	
		
		if(!is_drifting):
			add_drift_line()
			is_drifting = true
		else: 
			draw_drift_line()

	else:
		is_drifting = false
		
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

