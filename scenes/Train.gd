extends KinematicBody2D

const ROT_SPEED = deg2rad(0.1)
const MAX_ROT = deg2rad(16)
const MIN_ROT = -MAX_ROT

onready var info = $"../Info"
onready var track = $"../Track"
onready var player = $"../Player"
onready var width = $"Sprite".region_rect.end.x

func _ready():
        info.set_data("Train Width", width)

func _physics_process(delta):
        # NOTE horizontal distance will shrink as bed rotates and need to account for walls, so use ~80% max
        var percent_distance = 100 * abs(player.position.x) / (width * 0.5)
        info.set_data("Percent Distance from Center", percent_distance)
        if percent_distance > 20:
                var rot_mult = percent_distance + 20
                if player.position.x > 0:
                        rotation += ROT_SPEED * delta * rot_mult
                else:
                        rotation -= ROT_SPEED * delta * rot_mult

                if rotation < MIN_ROT || rotation > MAX_ROT:
                        track.brake(delta)

                rotation = clamp(rotation, MIN_ROT, MAX_ROT)

        info.set_data("Bed Rotation", rotation)
