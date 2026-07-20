extends Node
## Random Access Memory.
class_name RAM
## Place where everything is stored.
var memory : PackedByteArray
## Central Processing Unit.
var cpu : CPU
## Configures how big the RAM array is.
const size : int = 256
## Wipes all content in RAM.
func clear() -> void:
	memory.clear()
	memory.resize(size)
## Prepares RAM.
func _ready() -> void:
	name = "RAM"
	clear()
## Reads a specific byte in memory.
func read(byte : int) -> int:
	if byte > size:
		cpu.panic("OUT OF BOUNDS MEMORY")
	return memory.get(byte)
## Writes to a specific byte in memory.
func write(byte : int,content : int) -> void:
	if byte > size:
		cpu.panic("OUT OF BOUNDS MEMORY")
	memory.set(byte,content)
