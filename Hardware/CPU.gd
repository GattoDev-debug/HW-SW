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
	if "ppu" in rom:
		rom.ppu = ppu
	if "apu" in rom:
		rom.apu = apu
	if "cpu" in rom:
		rom.cpu = self
	add_child(rom)
	await get_tree().process_frame 	
	if rom.name != "ROM": panic("ROM NAME MISMATCH")
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
func panic(short_reason: String,full_reason : String = ""):
	crashed = true
	halted = true
	emit_signal("cpu_panic", short_reason)
	show_panic_screen(short_reason,full_reason)
func show_panic_screen(short_reason: String,full_reason: String):
	#ppu.test_pattern()
	await get_tree().process_frame
	ppu.rectfill(4, 4, 256, 16, Color.BLACK)
	ppu.rectfill(4, 20, 256, 16, Color.BLACK)
	ppu.rectfill(4, 45, 256, 16, Color.BLACK)
	await get_tree().process_frame
	ppu.text(
		8,
		8,
		"ILLEGAL INSTRUCTION",
		Color.WHITE
	)

	ppu.text(
		8,
		24,
		short_reason,
		Color.WHITE
	)
	ppu.text(
		8,
		50,
		full_reason,
		Color.WHITE
	)
