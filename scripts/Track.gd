extends StaticBody2D
class_name Track

const SPEED_MIN = 30
const SPEED_MAX = 1000
const ACCEL_SPEED = 10.0
const BRAKE_SPEED = 15.0

export var track_length = 50000

onready var game = $"../Game Manager"
onready var info = $"../Info"
onready var progress_bar = $"../UI/Progress"
onready var screen_width = get_viewport().size.x

var brake_speed: float
var is_braking = false
var speed: float

func _physics_process(delta):
        speed += delta * ACCEL_SPEED
        position.x -= speed * delta
        if position.x < -(screen_width / 2):
                position.x += screen_width
        #info.text = "Track X: " + str(position.x)
        info.set_data("Train Speed", "%.2f" % speed)

        if speed < SPEED_MIN:
                game.end_game()

        speed = clamp(speed, 0, SPEED_MAX)

        progress_bar.value += speed * delta
        if progress_bar.value >= track_length:
                game.end_level()

func brake(delta):
        brake_speed += BRAKE_SPEED * delta
        speed -= brake_speed * delta
        info.set_data("Brake Speed", "%.2f" % brake_speed)

func reset(length):
        reset_brake()
        progress_bar.value = 0
        speed = SPEED_MIN
        track_length = length
        progress_bar.max_value = track_length

func reset_brake():
        brake_speed = 0