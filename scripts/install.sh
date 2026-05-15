#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$REPO_ROOT"

if [ ! -d "dist/midi-player" ]; then
    echo "Run ./scripts/build.sh first."
    exit 1
fi

DEST="/data/UserData/schwung/modules/midi_fx/midi-player"
ssh ableton@move.local "mkdir -p $DEST/MIDI"
scp -r dist/midi-player/* ableton@move.local:$DEST/
ssh ableton@move.local "chmod -R a+rw $DEST"
echo "Installed to $DEST"
echo "Drop .mid files into $DEST/MIDI/ via SSH/SMB."
