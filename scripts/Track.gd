extends StaticBody2D
class_name Track

const ACCEL_SPEED = 5
const BRAKE_SPEED = 10

export var initial_speed = 10

onready var info = $"../Info"
onready var screen_width = get_viewport().size.x
onready var speed = initial_speed

func _physics_process(delta):
        speed += delta * ACCEL_SPEED
        position.x -= speed * delta
        if position.x < -(screen_width / 2):
                position.x += screen_width
        #info.text = "Track X: " + str(position.x)
        info.set_data("Track Pos", position.x)
        info.set_data("Track Speed", speed)

func brake(delta):
        speed -= delta * BRAKE_SPEED
        speed = max(speed, 0)
