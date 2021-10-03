extends KinematicBody2D
class_name Entity

const GRAVITY = 98
const PUSH_SPEED = 150
const PUSH_TIME = 0.1

var push_direction = 0
var push_time = 0
var velocity = Vector2.ZERO

func _physics_process(delta):
        if push_time > 0:
                push_time -= delta
                velocity.x = push_direction * PUSH_SPEED
                if push_time <= 0:
                        push_direction = 0
                        push_time = 0
                        velocity.x = 0

        velocity.y += GRAVITY * delta
        velocity = move_and_slide(velocity)

func push(direction):
        if direction != push_direction:
                push_time = 0
        push_time += PUSH_TIME
        push_direction = direction
