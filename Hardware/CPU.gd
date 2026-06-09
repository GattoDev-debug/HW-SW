extends Node
class_name CPU

## CPU (Central Processing Unit)

var ppu: PPU
var apu: APU
var rom: ROM

var halted := false

func _ready():

	get_window().size = Vector2(512, 512)
	get_window().move_to_center()

	## create hardware
	ppu = PPU.new()
	apu = APU.new()

	add_child(ppu)
	add_child(apu)



	## load ROM
	rom = ROM.new()

	## connect hardware to ROM
	rom.ppu = ppu
	rom.apu = apu

	add_child(rom)




func _process(delta):

	# ENTER = HALT CPU

	if Input.is_action_just_pressed("ui_accept"):

		halted = !halted

		if halted:
			print("CPU HALTED")
		else:
			print("CPU RESUMED")

	# stop execution while halted
	if halted:
		return

	# execute ROM
	rom.tick(delta)
