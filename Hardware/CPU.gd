extends Node
class_name CPU

## CPU (Central Processing Unit)
@export_file("*.gd") var rom_file : String = "res://Software/ROM.gd"
## Picture Processing Unit
var ppu: PPU
## Audio Processing Unit
var apu: APU
## Read Only Memory
var rom: Node
## Random Access Memory
var ram: RAM
## Is game paused?
var halted := false
## Tells any listening nodes that the game has crashed.
signal cpu_panic(reason)
## Did game crash?
var crashed := false

func _ready():
	rom = prepare_rom(rom_file)
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
	if rom.name != "ROM": panic("ROM FAIL", "PLEASE SET ROM IN CPU FILE")
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
	ram.write(ram.size-1,Performance.get_monitor(Performance.TIME_FPS))

	rom.tick(delta)
	ram.write(ram.size-1,Performance.get_monitor(Performance.TIME_FPS))
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
	ppu.clear()
	crashed = true
	halted = true
	show_panic_screen(short_reason,full_reason)
	emit_signal("cpu_panic", short_reason)
## Helper for panic()
func show_panic_screen(short_reason: String, full_reason: String):
	await get_tree().process_frame

	ppu.text(8, 8, "ILLEGAL INSTRUCTION", Color.WHITE)
	ppu.text(8, 24, short_reason, Color.WHITE)
	ppu.text(8, 40, full_reason, Color.WHITE)

	var bytes_per_row := 8
	var y := 64
	var skipped_rows := false

	for start_addr in range(0, ram.size, bytes_per_row):
		var has_data := false

		# Does this row contain any non-zero bytes?
		for i in range(bytes_per_row):
			var addr := start_addr + i
			if addr < ram.size and ram.read(addr) != 0:
				has_data = true
				break

		# Skip empty rows
		if !has_data:
			skipped_rows = true
			continue

		if skipped_rows:
			ppu.text(8, y, "...")
			y += 8
			skipped_rows = false

		var line := "%02X: " % start_addr

		for i in range(bytes_per_row):
			var addr := start_addr + i
			if addr >= ram.size:
				break

			line += "%02X " % ram.read(addr)

		ppu.text(8, y, line, Color.WHITE)
		y += 8

		if y >= ppu.HEIGHT - 8:
			break
func prepare_rom(rom_path : String) -> Node:
	var node = Node.new()
	node.set_script(load(rom_path))
	return node
