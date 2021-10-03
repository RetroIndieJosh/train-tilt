extends KinematicBody2D

onready var info = $"../Info"

export var initial_speed = 100

onready var screen_width = get_viewport().size.x

func _physics_process(_delta):
        var _col = move_and_collide(Vector2.LEFT * initial_speed)
        if position.x < -(screen_width / 2):
                position.x += screen_width
        info.text = "Track X: " + str(position.x)
