extends Node

@export var obstacle : PackedScene;
@export var coin : PackedScene;

var last_obstacle_position : String;
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
	else:
		game_over();
		
	score += delta;
	var formatted_score : String = str(score);
	var decimal_index = formatted_score.find(".");
	formatted_score = formatted_score.left(decimal_index + 3);
	$UI/HealthBar/ScoreLabel.text = formatted_score;


func _on_spawner_timer_timeout():
	var random : int = randi() % 2;
	var obstacle_instance : Area2D = obstacle.instantiate();
	add_child(obstacle_instance);
	obstacle_instance.position.x = spawned_object_position_x;
	obstacle_instance.body_entered.connect(_on_obstacle_collided);
	
	if random == 0:
		obstacle_instance.position.y = 200;
		last_obstacle_position = "up";
	else:
		obstacle_instance.position.y = 800;
		obstacle_instance.scale.y *= -1;
		last_obstacle_position = "down";
		
func _on_obstacle_collided(body : Node2D) -> void:
	if body.is_in_group("Player"):
		game_over();


func _on_coin_timer_timeout():
	var random_position : int = randi_range(100, 700);
	var coin_instance : Area2D = coin.instantiate();
	if last_obstacle_position == "up" && random_position <= 460:
		return;
	if last_obstacle_position == "down" && random_position >= 500:
		return;
	add_child(coin_instance);
	coin_instance.position.x = spawned_object_position_x;
	coin_instance.position.y = random_position;
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance));

func _on_coin_collided(body : Node2D, coin_instance : Area2D) -> void:
	if body.is_in_group("Player"):
		score += 5;
		health += 10;
		coin_instance.queue_free();
	
	if health > 100:
		health = 100;

func game_over() -> void:
	$GameOver.show();
	get_tree().paused = true;
