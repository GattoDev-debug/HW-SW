extends Node

class_name PPU
## PPU (Picture Processing Unit)
##
## "Fast" software framebuffer renderer.
##
## Features:
## - Direct pixel rendering
## - Framebuffer memory
## - Primitive drawing
## - Software rasterization

## Internal render resolution
const WIDTH := 256
const HEIGHT := 256
## FONTs
var FONT = {

	"A": [
		"0110",
		"1001",
		"1111",
		"1001",
		"1001"
	],

	"B": [
		"1110",
		"1001",
		"1110",
		"1001",
		"1110"
	],

	"C": [
		"0111",
		"1000",
		"1000",
		"1000",
		"0111"
	],

	"D": [
		"1110",
		"1001",
		"1001",
		"1001",
		"1110"
	],

	"E": [
		"1111",
		"1000",
		"1110",
		"1000",
		"1111"
	],

	"F": [
		"1111",
		"1000",
		"1110",
		"1000",
		"1000"
	],

	"G": [
		"0111",
		"1000",
		"1011",
		"1001",
		"0111"
	],

	"H": [
		"1001",
		"1001",
		"1111",
		"1001",
		"1001"
	],

	"I": [
		"111",
		"010",
		"010",
		"010",
		"111"
	],

	"J": [
		"0011",
		"0001",
		"0001",
		"1001",
		"0110"
	],

	"K": [
		"1001",
		"1010",
		"1100",
		"1010",
		"1001"
	],

	"L": [
		"1000",
		"1000",
		"1000",
		"1000",
		"1111"
	],

	"M": [
		"10001",
		"11011",
		"10101",
		"10001",
		"10001"
	],

	"N": [
		"1001",
		"1101",
		"1011",
		"1001",
		"1001"
	],

	"O": [
		"0110",
		"1001",
		"1001",
		"1001",
		"0110"
	],

	"P": [
		"1110",
		"1001",
		"1110",
		"1000",
		"1000"
	],

	"Q": [
		"0110",
		"1001",
		"1001",
		"1011",
		"0111"
	],

	"R": [
		"1110",
		"1001",
		"1110",
		"1010",
		"1001"
	],

	"S": [
		"0111",
		"1000",
		"0110",
		"0001",
		"1110"
	],

	"T": [
		"11111",
		"00100",
		"00100",
		"00100",
		"00100"
	],

	"U": [
		"1001",
		"1001",
		"1001",
		"1001",
		"0110"
	],

	"V": [
		"10001",
		"10001",
		"10001",
		"01010",
		"00100"
	],

	"W": [
		"10001",
		"10001",
		"10101",
		"11011",
		"10001"
	],

	"X": [
		"1001",
		"1001",
		"0110",
		"1001",
		"1001"
	],

	"Y": [
		"10001",
		"01010",
		"00100",
		"00100",
		"00100"
	],

	"Z": [
		"1111",
		"0001",
		"0010",
		"0100",
		"1111"
	],

	"0": [
		"0110",
		"1001",
		"1001",
		"1001",
		"0110"
	],

	"1": [
		"010",
		"110",
		"010",
		"010",
		"111"
	],

	"2": [
		"1110",
		"0001",
		"0110",
		"1000",
		"1111"
	],

	"3": [
		"1110",
		"0001",
		"0110",
		"0001",
		"1110"
	],

	"4": [
		"1001",
		"1001",
		"1111",
		"0001",
		"0001"
	],

	"5": [
		"1111",
		"1000",
		"1110",
		"0001",
		"1110"
	],

	"6": [
		"0111",
		"1000",
		"1110",
		"1001",
		"0110"
	],

	"7": [
		"1111",
		"0001",
		"0010",
		"0100",
		"0100"
	],

	"8": [
		"0110",
		"1001",
		"0110",
		"1001",
		"0110"
	],

	"9": [
		"0110",
		"1001",
		"0111",
		"0001",
		"1110"
	],

	" ": [
		"000",
		"000",
		"000",
		"000",
		"000"
	],

	":": [
		"0",
		"1",
		"0",
		"1",
		"0"
	],

	".": [
		"0",
		"0",
		"0",
		"1",
		"0"
	],

	"-": [
		"000",
		"000",
		"111",
		"000",
		"000"
	],
	"(": [
		"010",
		"100",
		"100",
		"100",
		"010"
	],
	")": [
		"010",
		"001",
		"001",
		"001",
		"010"
	],
	"!": [
		"1",
		"1",
		"1",
		"0",
		"1"
	],
	"?": [
		"110",
		"001",
		"010",
		"000",
		"010"
	],
	",": [
		"00",
		"00",
		"00",
		"01",
		"10"
	],
	"'": [
		"1",
		"1",
		"0",
		"0",
		"0"
	],
	"\"": [
		"101",
		"101",
		"000",
		"000",
		"000"
	],
	"+": [
		"000",
		"010",
		"111",
		"010",
		"000"
	],
	"*": [
		"000",
		"101",
		"010",
		"101",
		"000"
	],
	"/": [
		"001",
		"001",
		"010",
		"100",
		"100"
	],
	"=": [
		"000",
		"111",
		"000",
		"111",
		"000"
	],
	"#": [
		"01010",
		"11111",
		"01010",
		"11111",
		"01010"
	],
	"@": [
		"0110",
		"1001",
		"1011",
		"1010",
		"0110"
	],
	"%": [
		"1001",
		"0010",
		"0100",
		"1001",
		"0000"  
	],
	"_": [
		"000",
		"000",
		"000",
		"000",
		"111"
	],
	"<": [
		"001",
		"010",
		"100",
		"010",
		"001"
	],
	">": [
		"100",
		"010",
		"001",
		"010",
		"100"
	],
	"[": [
		"11",
		"10",
		"10",
		"10",
		"11"
	],
	"]": [
		"11",
		"01",
		"01",
		"01",
		"11"
	],
	"&": [
		"0110",
		"1001",
		"0110",
		"1001",
		"0111"
	],
	";": [
		"0",
		"1",
		"0",
		"1",
		"1"
	],
	"^": [
		"010",
		"101",
		"000",
		"000",
		"000"
	],
	"~": [
		"000",
		"010",
		"101",
		"000",
		"000"
	],
	"|": [
		"1",
		"1",
		"1",
		"1",
		"1"
	],
	"\\": [
		"100",
		"100",
		"010",
		"001",
		"001"
	],
}
## Image buffer
var image: Image
var cpu: CPU
## GPU texture
var texture: ImageTexture

## Display sprite
var display: Sprite2D

## Fake VRAM / framebuffer
var framebuffer := []

## True if image changed this frame
var dirty := false

## Here for compatibility, does nothing.
func render() -> void:
	pass
## Initializes the PPU
func _ready() -> void:

	name = "PPU"

	## Allocate framebuffer
	framebuffer.resize(WIDTH * HEIGHT)

	## Fill framebuffer
	for i in range(framebuffer.size()):
		framebuffer[i] = Color.BLACK

	## Create image
	image = Image.create(
		WIDTH,
		HEIGHT,
		false,
		Image.FORMAT_RGBA8
	)

	image.fill(Color.BLACK)

	## Create texture
	texture = ImageTexture.create_from_image(image)

	## Create display sprite
	display = Sprite2D.new()
	display.texture = texture
	display.position = Vector2(WIDTH / 2, HEIGHT / 2)
	display.scale = Vector2(1,1)
	add_child(display)



## Upload texture only when modified
func _process(_delta):

	if dirty:

		texture.update(image)

		dirty = false



## Sets a single pixel
func pset(x: int, y: int, color: Color) -> void:

	## Bounds check
	if x < 0 or x >= WIDTH:
		return

	if y < 0 or y >= HEIGHT:
		return

	## Store in framebuffer
	framebuffer[y * WIDTH + x] = color

	## Write directly into image
	image.set_pixel(x, y, color)

	dirty = true



## Gets a pixel
func pget(x: int, y: int) -> Color:

	if x < 0 or x >= WIDTH:
		return Color.BLACK

	if y < 0 or y >= HEIGHT:
		return Color.BLACK
	return framebuffer[y * WIDTH + x]



## Clears framebuffer
func clear(color := Color.BLACK) -> void:

	for y in range(HEIGHT):
		for x in range(WIDTH):

			framebuffer[y * WIDTH + x] = color
			image.set_pixel(x, y, color)

	dirty = true



## Draws a line
func line(x0: int, y0: int, x1: int, y1: int, color: Color) -> void:

	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)

	var sx = -1 if x0 > x1 else 1
	var sy = -1 if y0 > y1 else 1

	var err = dx - dy

	while true:

		pset(x0, y0, color)

		if x0 == x1 and y0 == y1:
			break

		var e2 = err * 2

		if e2 > -dy:
			err -= dy
			x0 += sx

		if e2 < dx:
			err += dx
			y0 += sy



## Draws rectangle outline
func rect(x: int, y: int, w: int, h: int, color: Color) -> void:

	line(x, y, x + w, y, color)
	line(x + w, y, x + w, y + h, color)
	line(x + w, y + h, x, y + h, color)
	line(x, y + h, x, y, color)



## Draws filled rectangle
func rectfill(x: int, y: int, w: int, h: int, color: Color) -> void:

	for py in range(y, y + h):
		line(x, py, x + w, py, color)



## Draws circle outline
func circle(cx: int, cy: int, radius: int, color: Color) -> void:

	var x := radius
	var y := 0
	var err := 0

	while x >= y:

		pset(cx + x, cy + y, color)
		pset(cx + y, cy + x, color)
		pset(cx - y, cy + x, color)
		pset(cx - x, cy + y, color)

		pset(cx - x, cy - y, color)
		pset(cx - y, cy - x, color)
		pset(cx + y, cy - x, color)
		pset(cx + x, cy - y, color)

		y += 1

		if err <= 0:
			err += 2 * y + 1

		if err > 0:
			x -= 1
			err -= 2 * x + 1



## Draws filled circle
func circlefill(cx: int, cy: int, radius: int, color: Color) -> void:

	for y in range(-radius, radius + 1):

		var xx = int(sqrt(radius * radius - y * y))

		line(
			cx - xx,
			cy + y,
			cx + xx,
			cy + y,
			color
		)



## Draws triangle outline
func triangle(
	x1: int, y1: int,
	x2: int, y2: int,
	x3: int, y3: int,
	color: Color
) -> void:

	line(x1, y1, x2, y2, color)
	line(x2, y2, x3, y3, color)
	line(x3, y3, x1, y1, color)



## Triangle interpolation helper
func interp(y: int, a: Vector2i, b: Vector2i) -> int:

	if a.y == b.y:
		return a.x

	return int(
		a.x + (float(y - a.y) / float(b.y - a.y)) * (b.x - a.x)
	)



## Draws filled triangle
func trianglefill(
	x1: int, y1: int,
	x2: int, y2: int,
	x3: int, y3: int,
	color: Color
) -> void:

	var points = [
		Vector2i(x1, y1),
		Vector2i(x2, y2),
		Vector2i(x3, y3)
	]

	points.sort_custom(func(a, b): return a.y < b.y)

	var v1 = points[0]
	var v2 = points[1]
	var v3 = points[2]

	for y in range(v1.y, v3.y + 1):

		var xa
		var xb

		if y < v2.y:
			xa = interp(y, v1, v2)
			xb = interp(y, v1, v3)
		else:
			xa = interp(y, v2, v3)
			xb = interp(y, v1, v3)

		if xa > xb:
			var t = xa
			xa = xb
			xb = t

		line(xa, y, xb, y, color)



## Draws sprite from 2D color array
func sprite(x: int, y: int, sprite_data: Array) -> void:

	for py in range(sprite_data.size()):

		for px in range(sprite_data[py].size()):

			var col = sprite_data[py][px]

			if col.a > 0.0:
				pset(x + px, y + py, col)

## Draw text on screen.
func text(
	x: int,
	y: int,
	str: Variant,
	color: Color
) -> void:

	var cursor_x = x
	str = str(str).to_upper()
	
	for char in str:
		if not FONT.has(char):
			char = "?"
		draw_char(
			cursor_x,
			y,
			char,
			color
		)

		cursor_x += 6
		
## Helper for text()
func draw_char(
	x: int,
	y: int,
	char: String,
	color: Color
) -> void:

	if not FONT.has(char):
		cpu.panic("CHAR NOT FOUND")
		return
	var glyph = FONT[char]

	for py in range(glyph.size()):

		var row = glyph[py]

		for px in range(row.length()):

			if row[px] == "1":
				pset(
					x + px,
					y + py,
					color
				)
## Debug test pattern
func test_pattern() -> void:

	for y in range(HEIGHT):
		for x in range(WIDTH):

			pset(
				x,
				y,
				Color(
					float(x) / WIDTH,
					float(y) / HEIGHT,
					0.2
				)
			)
