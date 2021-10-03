extends Node

onready var rij_button = $"../UI/RIJ"
onready var time = $"../Time"

var elapsed = 0
var game_over = false
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
                return
        elif Input.is_action_just_pressed("pause"):
                get_tree().paused = true
                time.text = "PAUSED\n"
                time.text += "Press ESC or START/PAUSE to return\n"
                time.text += "Press Q or BACK/SELECT/SHARE to quit"
                return
        elapsed += delta
        var minutes = int(floor(elapsed / 60.0))
        var seconds = int(floor(elapsed)) % 60
        time.text = "%02d:%02d" % [minutes, seconds]

func _ready():
        end_level(true)

func end_level(first=false):
        timer_running = false
        get_tree().paused = true
        if first:
                time.text = "TILT TRAIN\n"
                time.text += "by RetroIndieJosh (Joshua McLean)\n"
                time.text += "for Ludum Dare 49\n"
                time.text += "constructed in ~9.5 hours\n"
        else:
                time.text = "Level complete! Completed in %0.2f sec\n" % elapsed
        time.text += "Press JUMP to start the next level"

func end_game():
        end_level()
        time.text = "GAME OVER"
        time.text += "Press ESC or START/PAUSE to restart\n"
        time.text += "Press Q or BACK/SELECT/SHARE to quit"
        game_over = true

func start_level():
        rij_button.visible = false
        elapsed = 0
        timer_running = true
        get_tree().paused = false

func _on_RIJ_pressed():
        print("open link")
        var _i = OS.shell_open("https://retroindiejosh.itch.io")
        rij_button.visible = false
