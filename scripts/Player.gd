extends Entity

const COLOR_NORMAL = Color(1, 1, 1)
const COLOR_HIGHLIGHT = Color(0.6, 0.6, 1)

onready var forward_detector = $"Forward Detector"
onready var info = $"../Info"
onready var line = $"../Line"
onready var sprite = $"Sprite"
onready var up_detector_left = $"Up Detector L"
onready var up_detector_right = $"Up Detector R"

onready var detect_distance = forward_detector.cast_to.x

var held: Entity = null

var can_grab = true
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
                sprite.modulate = COLOR_HIGHLIGHT
        else:
                sprite.modulate = COLOR_NORMAL

        #dbg_draw_detector()
        info.text = ""
        if forward_detector.is_colliding():
                var target = forward_detector.get_collider()
                forward_collide(target)

        if held != null:
                held.position = position + Vector2.UP * 36
                info.set_data("Holding", "%s at %s" % [held.name, held.position])
                if Input.is_action_just_pressed("grab"):
                        throw()
        if not can_grab and Input.is_action_just_released("grab"):
                can_grab = true

        var crush_right = up_detector_right.is_colliding()
        var crush_left = up_detector_left.is_colliding()
        
        if crush_left:
                grab(up_detector_left.get_collider())
        elif crush_right:
                grab(up_detector_right.get_collider())
        info.set_data("Player at", "%s" % position)

func dbg_draw_detector():
        line.clear_points()
        line.add_point(position)
        line.add_point(position + forward_detector.cast_to)

func forward_collide(target):
        if not target is Entity:
                return
        if held == null and Input.is_action_pressed("grab"):
                grab(target)
        else:
                info.set_data("Last Push", "%s %d" % [target.name, facing])
                target.push(facing)

func grab(target):
        if not can_grab:
                return
        held = target
        held.use_gravity = false
        held.get_node("Sprite").modulate = COLOR_HIGHLIGHT
        info.set_data("Last Grab", target.name)

func throw():
        held.use_gravity = true
        held.velocity.x = facing * 500
        held.velocity.y = -10
        held.slide_prevention = false
        held.get_node("Sprite").modulate = COLOR_NORMAL
        held = null
        can_grab = false