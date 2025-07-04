class_name Bounds extends Node2D

@onready var upper_left: Marker2D = %UpperLeft
@onready var lower_right: Marker2D = %LowerRight

var x_min:float
var x_max:float
var y_min:float
var y_max:float

func _ready() -> void:
	x_min = upper_left.position.x
	x_max = lower_right.position.x
	y_min = upper_left.position.y
	y_max = lower_right.position.y

func wrap_vector(v:Vector2) -> Vector2:
	if v.x < x_min:
		return Vector2(x_max,v.y)
	elif v.x > x_max:
		return Vector2(x_min,v.y)
	elif v.y < y_min:
		return Vector2(v.x,y_max)
	elif v.y > y_max:
		return Vector2(v.x,y_min)
	return v

func _process(_delta: float) -> void:
	pass
