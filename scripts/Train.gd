extends KinematicBody2D

enum Side { LEFT, RIGHT }

const ROT_SPEED = deg2rad(0.01)
const MAX_ROT = deg2rad(16)
const MIN_ROT = -MAX_ROT

export var allow_tilt = true

onready var info = $"../Info"
onready var track = $"../Track"
onready var player = $"../Player"
onready var width = $"Sprite".region_rect.end.x

func _ready():
        info.set_data("Train Width", width)

func _physics_process(delta):
        if not allow_tilt:
                return

        var weight_right = 0
        var weight_left = 0
        for c in $"..".get_children():
                if c is Entity:
                        var weight = calc_weight(c)
                        if c.position.x < 0:
                                weight_left += weight
                        else:
                                weight_right += weight

        # NOTE horizontal distance will shrink as bed rotates and need to account for walls, so use ~80% max
        info.set_data("Weight", "L %0.2f / R %0.2f" % [weight_left, weight_right])
        var total_weight = weight_right - weight_left
        rotation += ROT_SPEED * delta * total_weight
        if rotation < MIN_ROT || rotation > MAX_ROT:
                track.brake(delta)
        rotation = clamp(rotation, MIN_ROT, MAX_ROT)

        info.set_data("Bed Rotation", rotation)

# TODO zero if not touching
func calc_weight(entity) -> float:
        var percent_distance = 100 * abs(entity.position.x) / (width * 0.5)
        #info.set_data(entity.name + " % dist", percent_distance)
        if percent_distance < 20:
                return 0.0
        #info.set_data(entity.name + " weight", (percent_distance + 20) * entity.weight)
        return (percent_distance + 20) * entity.weight
