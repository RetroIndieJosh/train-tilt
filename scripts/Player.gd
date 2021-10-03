extends Entity
class_name Player

const COLOR_NORMAL = Color(1, 1, 1)
const COLOR_HIGHLIGHT = Color(0.6, 0.6, 1)
const HOLD_HEIGHT = 80
const THROW_SPEED_X = 1000
const THROW_SPEED_Y = 40

export var jump_speed = 300
export var walk_speed = 100

onready var down_detector = $"Down Detector"
onready var forward_detector = $"Forward Detector"
onready var detect_distance = forward_detector.cast_to.x
onready var info = $"../Info"
onready var line = $"../Line"
onready var sprite = $"Sprite"
onready var up_detector_left = $"Up Detector L"
onready var up_detector_right = $"Up Detector R"

onready var die_sound = preload("res://sfx/die.wav")
onready var grab_sound = preload("res://sfx/grab.wav")
onready var jump_sound = preload("res://sfx/jump.wav")
onready var throw_sound = preload("res://sfx/throw.wav")

var held_ent: Entity = null
var prev_held_ent: Entity = null

var can_grab = true
var facing = 1

func _physics_process(_delta):
        handle_walk()
        handle_jump()
        update_color()
        handle_forward_collide()
        handle_crush()
        info.set_data("Player at", "%s" % position)

func dbg_draw_detector():
        line.clear_points()
        line.add_point(position)
        line.add_point(position + forward_detector.cast_to)

func _die():
        game.play_sound(die_sound)
        game.end_game(false)
        queue_free()

func forward_collide(target):
        if not target is Entity:
                return
        if held_ent == null and Input.is_action_pressed("grab"):
                grab(target)
        else:
                info.set_data("Last Push", "%s %d" % [target.name, facing])
                target.push(facing)

func grab(target):
        if not can_grab or held_ent != null:
                return
        held_ent = target
        held_ent.use_gravity = false
        held_ent.get_node("Sprite").modulate = COLOR_HIGHLIGHT
        info.set_data("Last Grab", target.name)
        game.play_sound(grab_sound)

# when a box falls on the player, grab it
func handle_crush():
        var crush_right = up_detector_right.is_colliding()
        var crush_left = up_detector_left.is_colliding()
        if crush_left:
                var col = up_detector_left.get_collider()
                if col != prev_held_ent:
                       grab(col) 
        elif crush_right:
                var col = up_detector_right.get_collider()
                if col != prev_held_ent:
                       grab(col) 

func handle_forward_collide():
        #dbg_draw_detector()
        info.text = ""
        if forward_detector.is_colliding():
                var target = forward_detector.get_collider()
                forward_collide(target)

        if held_ent != null:
                held_ent.position = position + Vector2.UP * HOLD_HEIGHT
                info.set_data("Holding", "%s at %s" % [held_ent.name, held_ent.position])
                if Input.is_action_just_pressed("grab"):
                        throw()
        if not can_grab and Input.is_action_just_released("grab"):
                can_grab = true

func handle_jump():
        if Input.is_action_just_pressed("jump") and down_detector.is_colliding():
                if down_detector.get_collider() is Train:
                        velocity.y = -jump_speed
                game.play_sound(jump_sound)

func handle_walk():
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

func reset():
        held_ent = null
        prev_held_ent = null
        can_grab = true

func throw():
        held_ent.use_gravity = true
        held_ent.velocity.x = facing * THROW_SPEED_X
        held_ent.velocity.y = -THROW_SPEED_Y
        held_ent.slide_prevention = false
        held_ent.get_node("Sprite").modulate = COLOR_NORMAL
        prev_held_ent = held_ent
        held_ent = null
        can_grab = false
        game.play_sound(throw_sound)

func update_color():
        if Input.is_action_pressed("grab"):
                sprite.modulate = COLOR_HIGHLIGHT
        else:
                sprite.modulate = COLOR_NORMAL
