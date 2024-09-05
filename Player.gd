extends RigidBody2D


var impulse_force : int = 1200;

func _process(delta):
	if Input.is_action_just_pressed("space"):
		apply_central_impulse(Vector2.UP * impulse_force); 
	
	$Particles.position = Vector2(position.x - 50, position.y - 10);
