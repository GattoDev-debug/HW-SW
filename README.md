# HW-SW

A software-emulated retro hardware stack built in Godot Engine. Includes a CPU, PPU (graphics), and APU (audio) — all written in GDScript. Programs are written as ROM scripts that interface directly with the hardware components.


---

## Overview

| Component | Description |
|-----------|-------------|
| **CPU** | Orchestrates the system. Manages the PPU and APU, loads ROMs, and drives the main loop. |
| **PPU** | Software framebuffer renderer. Handles pixel drawing, primitives, and text. |
| **APU** | Real-time audio synthesizer. Pulse, triangle, and noise channels with a register interface. |

For full documentation, see the **[Wiki](../../wiki)**.

---

## Getting Started

**Requirements:** Godot Engine 4.6.3-stable

1. Clone the repository
2. Open the project in Godot
3. Press **F5** to run

### Controls

| Key | Action |
|-----|--------|
| Enter | Halt / resume the CPU |
| Page Down | Trigger a panic (demo ROM only) |

---

## Writing a ROM

ROMs are GDScript files that get loaded by the CPU and called every frame via `tick(delta)`. See `Software/ROM.gd` for a full example and `Software/Template.gd` for a blank starting point.

```gdscript
extends Node
class_name ROM

var ppu: PPU
var apu: APU
var cpu: CPU

func _enter_tree() -> void:
    name = "ROM"

func tick(delta: float):
    ppu.clear(Color.BLACK)
    ppu.text(8, 8, "HELLO WORLD", Color.WHITE)
```

Full guide: **[Writing a ROM](../../wiki/Writing-a-ROM)**

---

## Documentation

- [CPU](../../wiki/CPU) — lifecycle, halt, panic
- [PPU](../../wiki/PPU) — framebuffer, drawing functions, font
- [APU](../../wiki/APU) — channels, waveforms, register interface
- [Writing a ROM](../../wiki/Writing-a-ROM) — how to write programs for the system
