extends Entity

onready var forward_detector = $"Forward Detector"
onready var info = $"../Info"
onready var line = $"../Line"
onready var sprite = $"Sprite"

onready var detect_distance = forward_detector.cast_to.x

var held: Entity = null

var facing = 1
var walk_speed = 100

func _physics_process(_delta):
        velocity.x = 0
        if Input.is_action_pressed("left"):
                velocity.x = -walk_speed
                sprite.set_flip_h(true)
                forward_detector.cast_to.x = -detect_distance
                facing = -1
        elif Input.is_action_pressed("right"):
                velocity.x = walk_speed
                sprite.set_flip_h(false)
                forward_detector.cast_to.x = detect_distance
                facing = 1

        if Input.is_action_pressed("grab"):
                sprite.modulate = Color(0, 0, 1)
        else:
                sprite.modulate = Color(1, 1, 1)

        #dbg_draw_detector()
        info.text = ""
        if forward_detector.is_colliding():
                var target = forward_detector.get_collider()
                if target is Entity:
                        if held == null and Input.is_action_pressed("grab"):
                                held = target
                                held.use_gravity = false
                                info.set_data("Last Grab", target.name)
                        else:
                                info.set_data("Last Push", "%s %d" % [target.name, facing])
                                target.push(facing)

        if held != null:
                held.position = position + Vector2.UP * 36
                info.set_data("Holding", "%s at %s" % [held.name, held.position])
                if Input.is_action_just_pressed("grab"):
                        held.use_gravity = true
                        held.velocity.x = facing * 500
                        held.velocity.y = -10
                        held.slide_prevention = false
                        held = null

        info.set_data("Player at", "%s" % position)

func dbg_draw_detector():
        line.clear_points()
        line.add_point(position)
        line.add_point(position + forward_detector.cast_to)
