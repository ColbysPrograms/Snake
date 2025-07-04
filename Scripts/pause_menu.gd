class_name PauseMenu extends CanvasLayer

@onready var continue_button: Button = %ContinueButton

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_pause"):
		queue_free()

func _on_continue_button_pressed() -> void:
	queue_free()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
