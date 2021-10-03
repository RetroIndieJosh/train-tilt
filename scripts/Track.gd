extends StaticBody2D
class_name Track

const SPEED_MIN = 10
const SPEED_MAX = 1000
const ACCEL_SPEED = 10
const BRAKE_SPEED = 15

onready var info = $"../Info"
onready var progress_bar = $"../UI/Progress"
onready var screen_width = get_viewport().size.x
onready var speed = SPEED_MIN

export var track_length = 1000

func _ready():
        progress_bar.max_value = track_length

func _physics_process(delta):
        speed += delta * ACCEL_SPEED
        position.x -= speed * delta
        if position.x < -(screen_width / 2):
                position.x += screen_width
        #info.text = "Track X: " + str(position.x)
        info.set_data("Train Speed", "%.2f" % speed)

        if speed < SPEED_MIN:
                info.set_data("LOSE!", "LOSE!")

        speed = clamp(speed, 0, SPEED_MAX)

        progress_bar.value += speed * delta
        if progress_bar.value >= track_length:
                info.set_data("WIN!", "WIN!")

func brake(delta):
        speed -= delta * BRAKE_SPEED
