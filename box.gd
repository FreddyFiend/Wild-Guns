extends RigidBody2D

var hit_force = 50.0

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var dir = global_position.direction_to(get_global_mouse_position())
		apply_impulse(dir * hit_force)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body_rid.name)
