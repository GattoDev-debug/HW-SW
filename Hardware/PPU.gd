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

## Image buffer
var image: Image

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
