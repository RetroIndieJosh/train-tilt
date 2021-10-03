extends Node

const TRACK_LENGTH_MIN = 1000
const TRACK_LENGTH_SQR_INC = 100

onready var rij_button = $"../UI/RIJ"
onready var brake_player = $"../Brake Player"
onready var music_player = $"../Music Player"
onready var sound_player = $"../Sound Player"
onready var player = $"../Player"
onready var track = $"../Track"
onready var time = $"../Time"

onready var game_over_sound = preload("res://sfx/game-over.wav")

var cargo_delivered = 0
var elapsed = 0
var game_over = false
var level = 0
var timer_running = false

func _process(delta):
        if game_over:
                if Input.is_action_just_pressed("pause"):
                        var _f = get_tree().reload_current_scene()
                if Input.is_action_just_pressed("quit"):
                        get_tree().quit()
                return
        if not timer_running:
                if Input.is_action_just_pressed("jump"):
                        start_level()
                return
        if get_tree().paused:
                if Input.is_action_just_pressed("quit"):
                        get_tree().quit()
                elif Input.is_action_just_pressed("pause"):
                        get_tree().paused = false
                        music_player.stream_paused = false
                return
        elif Input.is_action_just_pressed("pause"):
                music_player.stream_paused = true
                get_tree().paused = true
                time.text = "PAUSED\n"
                time.text += "Press ESC or START/PAUSE to return\n"
                time.text += "Press Q or BACK/SELECT/SHARE to quit"
                return
        elapsed += delta
        var minutes = int(floor(elapsed / 60.0))
        var seconds = int(floor(elapsed)) % 60
        time.text = "Level %d\n" % level
        time.text += "%02d:%02d\n" % [minutes, seconds]
        time.text += "%0.1f MPH\n" % (track.speed / 10)
        time.text += "%0.2f Miles\n" % ((track.track_length - track.progress_bar.value) / 3600)

func _ready():
        end_level(true)

func end_level(first=false):
        var cargo = 0
        for c in $"..".get_children():
                if c is Entity and not c is Player:
                        c.queue_free()
                        cargo += 1
        cargo_delivered += cargo
        brake_player.stop()
        timer_running = false
        get_tree().paused = true
        if first:
                time.text = "TILT TRAIN\n"
                time.text += "by RetroIndieJosh (Joshua McLean)\n"
                time.text += "for Ludum Dare 49\n"
                time.text += "constructed in ~9.5 hours\n"
        else:
                time.text = "Level complete!\n"
                time.text += "Delivered %d cargo in %0.2f sec\n" % [cargo, elapsed]
                time.text += "Total cargo delivered: %d\n" % cargo_delivered
        time.text += "Press JUMP to start the next level"

func end_game(sound=true):
        end_level()
        time.text = "GAME OVER\n"
        time.text += "Press ESC or START/PAUSE to restart\n"
        time.text += "Press Q or BACK/SELECT/SHARE to quit"
        game_over = true
        if sound:
                play_sound(game_over_sound)

func start_level():
        track.reset(TRACK_LENGTH_MIN + TRACK_LENGTH_SQR_INC * level * level)
        player.reset()
        level += 1
        rij_button.visible = false
        elapsed = 0
        timer_running = true
        get_tree().paused = false
        brake_player.play()

func _on_RIJ_pressed():
        print("open link")
        var _i = OS.shell_open("https://retroindiejosh.itch.io")
        rij_button.visible = false

func play_sound(stream):
        if sound_player.is_playing():
                sound_player.stop()
        sound_player.stream = stream
        sound_player.play()
