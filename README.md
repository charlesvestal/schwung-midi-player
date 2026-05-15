# MIDI Player

A MIDI FX module for [Schwung](https://github.com/charlesvestal/schwung)
that plays Standard MIDI Files (`.mid`) into the chain slot's sound
generator, synced to Move's MIDI clock.

## Usage

1. Install via the Module Store (or build + install manually below).
2. SSH or SMB into your Move and drop `.mid` files into:
   `/data/UserData/schwung/modules/midi_fx/midi-player/MIDI/`
3. In a chain slot, load **MIDI Player** as the MIDI FX.
4. From the slot menu:
   - **Choose File…** — pick a `.mid` from the directory above.
   - **Track** — `All` (default) merges every track into one stream, or pick
     a single track.
   - **Loop** — `on` / `off`.
5. Press play on Move. The file follows Move's tempo via MIDI clock.

All notes are rewritten to channel 1 before being sent to the slot's synth.

## Building

```bash
./scripts/build.sh        # cross-compile via Docker, produces dist/midi-player-module.tar.gz
./scripts/install.sh      # scp to a Move on the network at move.local
```

## Limitations (v0.1)

- Tempo meta events in the `.mid` file are discarded; playback speed
  follows Move's MIDI clock.
- Song Position Pointer (`0xF2`) is not handled.
- Events are quantized to the 24 PPQN clock grid (sixteenth-note triplets
  at worst).
- SMPTE-division `.mid` files are not supported.

## License

MIT — see `LICENSE`.
