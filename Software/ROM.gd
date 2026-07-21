extends Node

## ROM / Program cartridge

var ppu: PPU
var apu: APU
var cpu: CPU
var t := 0.0

func _enter_tree() -> void:
	name = "ROM"
	apu.pulse1_enabled = true
	apu.pulse2_enabled = true
	apu.triangle_enabled = true
func tick(delta: float):

	t += delta
	update_audio()
	update_graphics()
	update_text()

	if Input.is_action_just_pressed("ui_page_down"):
		cpu.panic("MANUAL CRASH")
func update_text() -> void:


	ppu.text(8, 15, "APU DEBUG")
	ppu.text(8, 25, "P1 F: %s V: %s" % [apu.pulse1_freq, apu.pulse1_volume])
	ppu.text(8, 35, "P2 F: %s V: %s" % [apu.pulse2_freq, apu.pulse2_volume])
	ppu.text(8, 45, "TRI F: %s" % apu.triangle_freq)
	ppu.text(8, 55, "NOISE: %s" % apu.noise_enabled)
func update_audio():

	apu.pulse1_freq = 220 + sin(t * 2.0) * 180
	apu.pulse2_freq = 110 + cos(t * 3.5) * 90
	apu.triangle_freq = 55 + sin(t * 0.7) * 20

	apu.pulse1_volume = 0.08 + abs(sin(t * 4.0)) * 0.05
	apu.pulse2_volume = 0.04 + abs(cos(t * 2.0)) * 0.04

	apu.noise_enabled = (sin(t * 12.0) > 0.92)


func update_graphics():

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
	ppu.rectrot(
		128,
		128,
		50,
		t,
		Color.WHITE
	)

	## spinning triangle
	ppu.trianglerot(
		200,
		180,
		35,
		-t * 1.5,
		Color.CYAN
	)
