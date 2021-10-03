extends KinematicBody2D
class_name Entity

const DRAG = 1000
const GRAVITY = 9.8
const PUSH_JUMP = 20
const PUSH_SPEED = 200
const PUSH_TIME = 0.2

export var weight = 1

var slide_prevention = true
var push_direction = 0
var push_time = 0
var use_gravity = true
var velocity = Vector2.ZERO

func _die():
        queue_free()

func _physics_process(delta):
        if push_time > 0:
                push_time -= delta
                velocity.x = push_direction * PUSH_SPEED
                if push_time <= 0:
                        push_direction = 0
                        push_time = 0
                        velocity.x = 0

        if use_gravity:
                # double gravity going down
                if velocity.y < 0:
                        velocity.y += GRAVITY * 0.5
                else:
                        velocity.y += GRAVITY
        else:
                velocity.y = 0

        velocity = move_and_slide(velocity)

        # prevent sliding down slopes
        if slide_prevention:
                velocity.x = 0
        else:
                if velocity.x > 0:
                        velocity.x -= delta * DRAG
                else:
                        velocity.x += delta * DRAG
                if abs(velocity.x) < 1:
                        slide_prevention = true

        var slide_count = get_slide_count()
        if slide_count:
                var collision = get_slide_collision(slide_count - 1)
                var collider = collision.collider
                if collider is Track:
                        _die()

func push(direction):
        if direction != push_direction:
                push_time = 0
        push_time += PUSH_TIME
        #velocity.y -= PUSH_JUMP
        push_direction = direction
