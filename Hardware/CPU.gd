extends Node
class_name CPU

## CPU (Central Processing Unit)

## Picture Processing Unit
var ppu: PPU
## Audio Processing Unit
var apu: APU
## Read Only Memory
var rom: ROM
## Random Access Memory
var ram: RAM
## Is game paused?
var halted := false
## Tells any listening nodes that the game has crashed.
signal cpu_panic(reason)
## Did game crash?
var crashed := false

func _ready():

	get_window().size = Vector2(512, 512)
	get_window().move_to_center()

	## create hardware
	ppu = PPU.new()
	ram = RAM.new()
	apu = APU.new()
	ppu.cpu = self
	ram.cpu = self
	apu.cpu = self
	
	add_child(ppu)
	add_child(apu)
	add_child(ram)


	## load ROM
	rom = ROM.new()
	## connect hardware to ROM
	if "ppu" in rom: rom.ppu = ppu
	if "apu" in rom: rom.apu = apu
	if "ram" in rom: rom.ram = ram
	if "cpu" in rom: rom.cpu = self
	# RAM SELF TEST START
	var rst : PackedByteArray
	for i in range(ram.size): ram.write(i,randi_range(0,256))
	for i in range(ram.size): rst.append(ram.read(i))
	if not rst == ram.memory: panic("RAM FAIL")
	ram.clear()
	# RAM SELF TEST END
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
	#if "-" in str(rom.t): panic("NEGATIVE TIME")
	ppu.clear()
	rom.tick(delta)
## Pauses game execution.
func halt():

	halted = true

	print("CPU HALTED")
## Resumes game execution.
func resume():

	halted = false

	print("CPU RESUMED")
## Panic! Crashes Game.
func panic(short_reason: String = "",full_reason : String = ""):
	crashed = true
	halted = true
	emit_signal("cpu_panic", short_reason)
	show_panic_screen(short_reason,full_reason)
## Helper for panic()
func show_panic_screen(short_reason: String,full_reason: String):
	#ppu.test_pattern()
	await get_tree().process_frame
	ppu.rectfill(4, 4, 256, 16, Color.BLACK)
	if not short_reason == "": ppu.rectfill(4, 20, 256, 16, Color.BLACK)
	if not full_reason == "":ppu.rectfill(4, 45, 256, 16, Color.BLACK)
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
