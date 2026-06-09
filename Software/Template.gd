extends Node
#class_name ROM
## ROM / Program cartridge

var ppu: PPU
var cpu: CPU
func _enter_tree() -> void:
	name = "ROM"
func tick(delta: float):
	test_font()
	ppu.text(8,90,"shimmy shimmy yay shimmy yay shimmy yay",Color.WHITE)
	ppu.text(8,120,"drake (swalalala) drake (swalalala)",Color.WHITE)
func test_font() -> void:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 :.-%s()!?,'\"+*=/=#@_<>[]&;^~|\\"
	var x = 8
	var y = 8
	var max_width = ppu.WIDTH - 8

	for char in chars:
		ppu.text(x, y, char, Color.WHITE)
		x += 6
		if x >= max_width:
			x = 8
			y += 10
