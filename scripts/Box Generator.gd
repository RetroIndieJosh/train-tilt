extends Position2D

export var move_speed = 10
export var sec_per_box = 5

onready var info = $"../Info"
onready var game = $".."
onready var box = preload("res://scenes/Box.tscn")
onready var train = $"../Train Bed"

var elapsed = 0
var total_elapsed = 0

func _process(delta):
        total_elapsed += delta
        var max_x = train.width * 0.4
        position.x = sin(total_elapsed) * max_x
        info.set_data("Box Spawn X", position.x)

        elapsed += delta
        if elapsed > sec_per_box:
                spawn_box()
                elapsed -= sec_per_box

        if Input.is_action_just_pressed("box"):
                spawn_box()

func spawn_box():
        var new_box = box.instance()
        new_box.position = position
        game.add_child(new_box)
