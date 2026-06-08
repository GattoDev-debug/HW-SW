extends Node
class_name CPU

## CPU (Central Processing Unit)
##
## The brains of this system's operation.
##

var ppu: PPU
var apu: APU

var t := 0.0

## fake CPU halted state
var halted := false

func _ready():
	get_window().size = Vector2(512,512)
	get_window().move_to_center()
	ppu = PPU.new()
	apu = APU.new()

	add_child(ppu)
	add_child(apu)


	## enable APU channels
	apu.pulse1_enabled = true
	apu.pulse2_enabled = true
	apu.triangle_enabled = true

	await get_tree().process_frame



func _process(delta):

	## ENTER = FREEZE CPU

	if Input.is_action_just_pressed("ui_accept"):

		halted = !halted

		if halted:
			print("CPU HALTED")
		else:
			print("CPU RESUMED")

	## CPU HALT

	if halted:
		return

	t += delta

	
	## AUDIO
	

	apu.pulse1_freq = 220 + sin(t * 2.0) * 180
	apu.pulse2_freq = 110 + cos(t * 3.5) * 90
	apu.triangle_freq = 55 + sin(t * 0.7) * 20

	apu.pulse1_volume = 0.08 + abs(sin(t * 4.0)) * 0.05
	apu.pulse2_volume = 0.04 + abs(cos(t * 2.0)) * 0.04

	apu.noise_enabled = (sin(t * 12.0) > 0.92)

	
	## GRAPHICS
	

	ppu.clear(Color.BLACK)

	## moving rectangle
	var rect_x = int(100 + sin(t) * 60)

	ppu.rectfill(
		rect_x,
		40,
		40,
		40,
		Color.RED
	)

	## bouncing circle
	var circle_y = int(128 + cos(t * 1.5) * 50)

	ppu.circlefill(
		60,
		circle_y,
		20,
		Color.GREEN
	)

	## rotating square
	draw_rotating_square(
		128,
		128,
		50,
		t,
		Color.WHITE
	)

	## spinning triangle
	draw_rotating_triangle(
		200,
		180,
		35,
		-t * 1.5,
		Color.CYAN
	)



func draw_rotating_square(
	cx: float,
	cy: float,
	size: float,
	angle: float,
	color: Color
):

	var half = size / 2.0

	var points = [
		Vector2(-half, -half),
		Vector2( half, -half),
		Vector2( half,  half),
		Vector2(-half,  half)
	]

	for i in range(points.size()):

		points[i] = points[i].rotated(angle)
		points[i] += Vector2(cx, cy)

	for i in range(4):

		var a = points[i]
		var b = points[(i + 1) % 4]

		ppu.line(
			int(a.x),
			int(a.y),
			int(b.x),
			int(b.y),
			color
		)



func draw_rotating_triangle(
	cx: float,
	cy: float,
	size: float,
	angle: float,
	color: Color
):

	var points = []

	for i in range(3):

		var a = angle + (TAU / 3.0) * i

		points.append(
			Vector2(
				cos(a) * size,
				sin(a) * size
			) + Vector2(cx, cy)
		)

	ppu.triangle(
		int(points[0].x),
		int(points[0].y),

		int(points[1].x),
		int(points[1].y),

		int(points[2].x),
		int(points[2].y),

		color
	)
