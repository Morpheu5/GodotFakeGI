extends Node3D

var timer_trick = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/MarginContainer/VBoxContainer/FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	$CanvasLayer/MarginContainer/VBoxContainer/TimerLabel.text = "[t] timer trick" if timer_trick else "[t] _process"
	if !timer_trick:
		var video_player: VideoStreamPlayer  = $SubViewport/SubViewportContainer/VideoStreamPlayer
		var tex = video_player.get_video_texture()
		var color = get_mean_color(tex)
		var light: SpotLight3D = $Room/Screen/SpotLight3D
		light.light_color = color

func _input(event):
	if Input.is_key_pressed(KEY_T) or (event is InputEventScreenTouch and event.pressed):
		timer_trick = !timer_trick

func _on_timer_timeout():
	if timer_trick:
		var video_player: VideoStreamPlayer  = $SubViewport/SubViewportContainer/VideoStreamPlayer
		var tex = video_player.get_video_texture()
		var color = get_mean_color(tex)
		var light: SpotLight3D = $Room/Screen/SpotLight3D
		light.light_color = color

func get_mean_color(t: Texture2D):
	if t == null:
		return Color(1, 0, 0)

	var i = t.get_image()
	if i == null:
		return Color(0, 1, 0)
		
	var s = i.get_size()
	var a = [
		i.get_pixel(s.x * 0.25, s.y * 0.25),
		i.get_pixel(s.x * 0.75, s.y * 0.25),
		i.get_pixel(s.x * 0.50, s.y * 0.50),
		i.get_pixel(s.x * 0.25, s.y * 0.75),
		i.get_pixel(s.x * 0.75, s.y * 0.75),
	]
	return (a[0] + a[1] + a[2] + a[3] + a[4]) / 5.0
