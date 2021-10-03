extends Node

onready var time = $"../Time"

var elapsed = 0
var timer_running = false

func _process(delta):
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
                time.text = "PAUSED / Press ESC or START/PAUSE to return / Press Q or BACK/SELECT/SHARE to quit"
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
                time.text = ""
        else:
                time.text = "Level complete! "
        time.text += "Press JUMP to start the next level"

func end_game():
        end_level()
        time.text = "GAME OVER"

func start_level():
        elapsed = 0
        timer_running = true
        get_tree().paused = false
