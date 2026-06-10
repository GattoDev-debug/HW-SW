extends Node

class_name APU
## APU (Audio Processing Unit)
##
## A simple software audio generator.
##
## Features:
## - Pulse wave channels
## - Triangle wave channel
## - Noise channel
## - Real-time audio synthesis

## Audio settings
const SAMPLE_RATE := 44100
const BUFFER_LENGTH := 0.05

## Audio player
var player: AudioStreamPlayer

## Audio playback buffer
var playback: AudioStreamGeneratorPlayback


## CHANNEL REGISTERS

var cpu: CPU
## Pulse channel 1
var pulse1_enabled := false
var pulse1_freq := 440.0
var pulse1_volume := 0.15
var pulse1_duty := 0.5

## Pulse channel 2
var pulse2_enabled := false
var pulse2_freq := 220.0
var pulse2_volume := 0.15
var pulse2_duty := 0.25

## Triangle channel
var triangle_enabled := false
var triangle_freq := 110.0
var triangle_volume := 0.15

## Noise channel
var noise_enabled := false
var noise_volume := 0.08

## Internal timing
var time := 0.0

## Fake hardware registers
var registers := {}




## INITIALIZATION

func _ready():

	name = "APU"

	## Create audio player
	player = AudioStreamPlayer.new()

	## Create generator stream
	var stream = AudioStreamGenerator.new()

	stream.mix_rate = SAMPLE_RATE
	stream.buffer_length = BUFFER_LENGTH

	player.stream = stream

	add_child(player)

	player.play()

	playback = player.get_stream_playback()

	## Initialize fake registers
	registers = {

		"PULSE1_FREQ": pulse1_freq,
		"PULSE1_VOL": pulse1_volume,
		"PULSE1_DUTY": pulse1_duty,

		"PULSE2_FREQ": pulse2_freq,
		"PULSE2_VOL": pulse2_volume,
		"PULSE2_DUTY": pulse2_duty,

		"TRI_FREQ": triangle_freq,
		"TRI_VOL": triangle_volume,

		"NOISE_VOL": noise_volume
	}



## MAIN AUDIO LOOP

func _process(delta):

	if playback == null:
		return

	fill_buffer(delta)


## AUDIO BUFFER GENERATION

func fill_buffer(_delta):

	var frames_available = playback.get_frames_available()

	for i in range(frames_available):

		var sample := 0.0

		## Pulse channel 1
		if pulse1_enabled:
			sample += pulse_wave(
				time,
				pulse1_freq,
				pulse1_duty
			) * pulse1_volume

		## Pulse channel 2
		if pulse2_enabled:
			sample += pulse_wave(
				time,
				pulse2_freq,
				pulse2_duty
			) * pulse2_volume

		## Triangle channel
		if triangle_enabled:
			sample += triangle_wave(
				time,
				triangle_freq
			) * triangle_volume

		## Noise channel
		if noise_enabled:
			sample += noise_wave() * noise_volume

		## Clamp audio
		sample = clamp(sample, -1.0, 1.0)

		## Stereo output
		playback.push_frame(Vector2(sample, sample))

		time += 1.0 / SAMPLE_RATE




## WAVE GENERATORS


## Pulse / square wave
func pulse_wave(
	t: float,
	freq: float,
	duty: float
) -> float:

	var phase = fmod(t * freq, 1.0)

	if phase < duty:
		return 1.0

	return -1.0



## Triangle wave
func triangle_wave(
	t: float,
	freq: float
) -> float:

	return abs(
		fmod(t * freq, 1.0) * 4.0 - 2.0
	) - 1.0



## Noise generator
func noise_wave() -> float:

	return randf_range(-1.0, 1.0)




## REGISTER ACCESS


## Writes to a fake hardware register
func write_register(
	reg: String,
	value
):

	registers[reg] = value

	match reg:

		"PULSE1_FREQ":
			pulse1_freq = value

		"PULSE1_VOL":
			pulse1_volume = value

		"PULSE1_DUTY":
			pulse1_duty = value

		"PULSE2_FREQ":
			pulse2_freq = value

		"PULSE2_VOL":
			pulse2_volume = value

		"PULSE2_DUTY":
			pulse2_duty = value

		"TRI_FREQ":
			triangle_freq = value

		"TRI_VOL":
			triangle_volume = value

		"NOISE_VOL":
			noise_volume = value



## Reads a fake hardware register
func read_register(reg: String):

	if registers.has(reg):
		return registers[reg]

	return null
