class_name HUD extends CanvasLayer

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel

func _ready() -> void:
	high_score_label.text = "High Score: " + str(Global.save_data.high_score)

func update_score(n:int):
	score_label.text = "Score: " + str(n)
