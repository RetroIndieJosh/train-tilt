extends Position2D

const SPEED_REDUCTION_MULT = 0.98

export var move_speed = 10
export var base_sec_per_box = 5

onready var info = $"../Info"
onready var game = $".."
onready var box = preload("res://scenes/Box.tscn")
onready var train = $"../Train Bed"

var elapsed = 0
var sec_per_box = 0
var total_elapsed = 0

func _process(delta):
        total_elapsed += delta
        var max_x = train.width * 0.4
        position.x = sin(total_elapsed) * max_x

        elapsed += delta
        if elapsed > sec_per_box:
                spawn_box()
                elapsed -= sec_per_box

        if Input.is_action_just_pressed("box"):
                spawn_box()

func _ready():
        reset(0)

func reset(level):
        sec_per_box = base_sec_per_box
        for _i in range(level):
                sec_per_box *= SPEED_REDUCTION_MULT

func spawn_box():
        var new_box = box.instance()
        new_box.position = position
        game.add_child(new_box)
        sec_per_box *= SPEED_REDUCTION_MULT
        info.set_data("Sec Per Box", sec_per_box)
