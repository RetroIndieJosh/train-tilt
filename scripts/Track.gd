extends StaticBody2D
class_name Track

const SPEED_MAX = 1000
const ACCEL_SPEED = 50
const BRAKE_SPEED = 100

export var initial_speed = 10

onready var info = $"../Info"
onready var progress_bar = $"../UI/Progress"
onready var screen_width = get_viewport().size.x
onready var speed = initial_speed

export var track_length = 100

func _ready():
        progress_bar.max_value = track_length

func _physics_process(delta):
        speed += delta * ACCEL_SPEED
        position.x -= speed * delta
        if position.x < -(screen_width / 2):
                position.x += screen_width
        #info.text = "Track X: " + str(position.x)
        info.set_data("Train Speed", "%.2f" % speed)
        speed = clamp(speed, 0, SPEED_MAX)

        progress_bar.value = speed * delta

func brake(delta):
        speed -= delta * BRAKE_SPEED
