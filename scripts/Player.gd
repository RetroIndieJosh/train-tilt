extends Entity


onready var forward_detector = $"Forward Detector"
onready var info = $"../Info"
onready var line = $"../Line"
onready var sprite = $"Sprite"

onready var detect_distance = forward_detector.cast_to.x

var walk_speed = 100

func _physics_process(_delta):
        velocity.x = 0
        if Input.is_action_pressed("left"):
                velocity.x = -walk_speed
                sprite.set_flip_h(true)
                forward_detector.cast_to.x = -detect_distance
        elif Input.is_action_pressed("right"):
                velocity.x = walk_speed
                sprite.set_flip_h(false)
                forward_detector.cast_to.x = detect_distance

        #dbg_draw_detector()
        info.text = ""
        if forward_detector.is_colliding():
                var col = forward_detector.get_collider()
                info.text = "Touching " + str(col)
                if col is Entity:
                        col.push(sign(velocity.x))

func _ready():
	pass

func dbg_draw_detector():
        line.clear_points()
        line.add_point(position)
        line.add_point(position + forward_detector.cast_to)
