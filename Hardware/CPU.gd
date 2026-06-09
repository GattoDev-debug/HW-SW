extends Node
class_name CPU

## CPU (Central Processing Unit)

var ppu: PPU
var apu: APU
var rom: ROM
var halted := false
signal cpu_panic(reason)

var crashed := false

func _ready():
	get_window().size = Vector2(512, 512)
	get_window().move_to_center()

	## create hardware
	ppu = PPU.new()
	apu = APU.new()
	ppu.cpu = self
	apu.cpu = self
	
	add_child(ppu)
	add_child(apu)



	## load ROM
	rom = ROM.new()

	## connect hardware to ROM
	rom.ppu = ppu
	rom.apu = apu
	rom.cpu = self
	add_child(rom)




func _process(delta):

	if crashed:
		return

	if Input.is_action_just_pressed("ui_accept"):
		if halted:
			resume()
		else:
			halt()
	if halted:
		return

	rom.tick(delta)
func halt():

	halted = true

	print("CPU HALTED")
func resume():

	halted = false

	print("CPU RESUMED")
## Panic! Crashes Game.
func panic(reason: String):

	crashed = true
	halted = true

	print("")
	print("CPU PANIC")
	print(reason)

	emit_signal("cpu_panic", reason)

	show_panic_screen(reason)
func show_panic_screen(reason: String):

	# background for title
	ppu.rectfill(4, 4, 120, 16, Color.BLACK)

	ppu.text(
		8,
		8,
		"CPU PANIC",
		Color.WHITE
	)

	# background for reason text
	ppu.rectfill(4, 20, 240, 16, Color.BLACK)

	ppu.text(
		8,
		24,
		reason,
		Color.WHITE
	)
