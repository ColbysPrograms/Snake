class_name Gameplay extends Node

const game_over_scene:PackedScene = preload("res://Scenes/game_over.tscn")
const pause_menu_scene:PackedScene = preload("res://Scenes/pause_menu.tscn")

@onready var head: Head = %Head as Head
@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = %Spawner as Spawner
@onready var hud: HUD = %HUD as HUD

var game_over_menu:GameOver
var pause_menu:PauseMenu
var time_between_move:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 4000.0
var move_dir: Vector2 = Vector2.ZERO # Vector2(1,0)
var snake_parts:Array[SnakePart] = []
var score:int:
	get:
		return score
	set(value):
		score = value
		hud.update_score(score)

func _ready() -> void:
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	
	time_since_last_move = time_between_move
	spawner.spawn_food()
	snake_parts.push_back(head)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_up") && move_dir != Vector2.DOWN:
		move_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down") && move_dir != Vector2.UP:
		move_dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_left") && move_dir != Vector2.RIGHT:
		move_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_right") && move_dir != Vector2.LEFT:
		move_dir = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_pause"):
		pause_game()

func _physics_process(delta: float) -> void:
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_move:
		update_snake()
		time_since_last_move = 0

func update_snake():
	var new_position:Vector2 = head.position + move_dir * Global.GRID_SIZE
	new_position = bounds.wrap_vector(new_position)
	head.move_to(new_position)
	
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position)

func _on_food_eaten():
	spawner.call_deferred("spawn_food")
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size() - 1].last_position)
	speed += 500.0
	score += 1

func _on_tail_added(tail:Tail):
	snake_parts.push_back(tail)

func _on_tail_collided():
	if not game_over_menu:
		game_over_menu = game_over_scene.instantiate() as GameOver
		add_child(game_over_menu)
		game_over_menu.set_score(score)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()

func pause_game():
	if not pause_menu:
		pause_menu = pause_menu_scene.instantiate() as PauseMenu
		add_child(pause_menu)
