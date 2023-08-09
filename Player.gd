extends CharacterBody2D


const SPEED = 50.0
var direction = Vector2()
var active = true
@onready var animation = $AnimationPlayer


func _on_ready():
	$Camera2D.make_current()



func _physics_process(delta):
	if(active):
		movement()
	else: 
		pass
	
	
	
func movement():
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	
	
	if direction.x || direction.y: 
		$Sprite2D.rotation =  atan2(direction.x, direction.y * -1)
		animation.play('run')
		velocity = direction.normalized() * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	


