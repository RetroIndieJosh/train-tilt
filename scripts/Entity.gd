extends KinematicBody2D
class_name Entity

const GRAVITY = 98

var walk_speed = 10
var velocity = Vector2.ZERO

func _physics_process(delta):
        velocity.x = 0
        if Input.is_action_pressed("left"):
                velocity.x = -walk_speed
        elif Input.is_action_pressed("right"):
                velocity.x = walk_speed
        velocity.y += GRAVITY * delta
        velocity = move_and_slide(velocity)