extends Node

@export var obstacle : PackedScene;

var dynamic_object_speed : int = 700;
var spawned_object_position_x : int = 1700;
var health_decrease_speed : int = 3;
var health : float = 100;
var score : float = 0;

func _process(delta):
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= delta * dynamic_object_speed;
		
	if health > 0:
		health -= delta * health_decrease_speed;
		$UI/HealthBar.value = health;
		
	score += delta;
	var formatted_score : String = str(score);
	var decimal_index = formatted_score.find(".");
	formatted_score = formatted_score.left(decimal_index + 3);
	$UI/HealthBar/ScoreLabel.text = formatted_score;


func _on_spawner_timer_timeout():
	var random : int = randi() % 2;
	var timer : float = randf();
	var timer_node = get_node("SpawnerTimer");
	timer_node.wait_time = timer;
	var obstacle_instance : Area2D = obstacle.instantiate();
	add_child(obstacle_instance);
	obstacle_instance.add_to_group("DynamicObject")
	obstacle_instance.position.x = spawned_object_position_x;
	
	if random == 0:
		obstacle_instance.position.y = 200;
	else:
		obstacle_instance.position.y = 800;
		obstacle_instance.scale.y *= -1;
